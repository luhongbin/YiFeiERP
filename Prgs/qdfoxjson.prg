* qdfoxJSON.PRG
* Quick & Dirty Foxpro JSON parser
*
* Author  : Victor Espina
* Version : 1.5
* Last upd: Abril 2012
*
* -------------------------------------------------------------------------
* VERSION HISTORY
*
* VES	Abr 14, 2012	1.5		- Correccion en el manejo de CR y LF en _encodeString y _decodeString (Juan Pablo MartÌn P, Espana)
*                               - Correccion en el metodo _encodeValue y Parse para el manejo de valores numericos (cortesia de Juan Pabloe Martin y Rafael Cano)
*
* VES   Mar 27, 2012	1.4		- Internal changes to handle special characters in string values
*								- Bug fixed in Clone() method of JSONObject class (reported and fixed by Claudio Luna)
* 								- New Canonical property in jsonHelper class
*
* VES   ?               1.3     - New Clone() method in JSONObject class
*
* VES	Feb 10, 2012	1.2		- Bug fixes in parseCursor() and encodeCursor() methods of jsonHelper class
*
* VES	Feb 9, 2012		1.1		- OOP rewrite
*                               - Added support for VFP objects
*                               - Added support to JSONObject() to be initialized with the response from a given URL
*                               - Added "stringDelimitator" property to jsonHelper class
*								- Added "quotePropertyNames" property to jsonHelper class
*
* VES	Jan 31, 2012	1.0		Initial version 
* -------------------------------------------------------------------------
*
* Usage:
* SET PROCEDURE TO qdfoxJSON ADDITIVE
* JSONStart()
*
* 1. Encoding an object to a JSON string using JSONObject (this is the preferred method):
*      myObject = JSONObject()
*      myObject.add("Name","foo")
*      myObject.add("Age",40)
*      jsonString = myObject.ToJSON()
*      ?jsonString --> "{name:'foo', age:40}"
*
*    To use canonical notation:
*     JSON.canonicalNotation = .T.
*     ?myObject.ToJSON() --> '{"name":"foo", "age":40}'
*
* 2. Encoding an object to a JSON string:
*      myObject = CREATEOBJECT("Empty")
*      ADDPROPERTY("Name","foo")
*      ADDPROPERTY("Age",40)
*      jsonString = JSON.Encode(myObject)
*
* 3. Parsing a JSON string using JSONObject (this is the preferred method):
*      myObject = JSONObject(jsonString)
*
* 4. Parsing a JSON string using Parse() method:
*      myObject = JSON.Parse(jsonString)
*
* 5. Creating a JSONObject manually:
*      myObject = JSONObject("{name:'Foo',age:40}")
*      ?myObject.Name --> 'Foo'
*      ?myObject.Age --> 40
*      myObject.Add("Sex","Male")
*      ?myObject.Sex --> 'Male'
*
*      myObject.addArray("Hobbies","['Read','Trekking','Football']")
*      ?myObject.Hobbies.Count --> 3
*      ?myObject.Hobbies[2] --> 'Trekking'
*
*      myObject.Add("Car","{Maker:'Hyundai',Model:'Accent',Year:2007}")
*      ?myObject.Car.Maker --> "Hyundai"
*      myObject.Car.Add("Engine","V4 1.3 lts")
*      ?myObject.Car.Engine --> 'V4 1.3 lts'
*
* 6. Creating a JSONObject from a declared schema: [1]
*      JSON.declareSchema("User",;
*          "{loginName:string,"+;
*          " fullName:string,"+;
*          " password:string,"+;
*          " lastLogin:datetime}")
*      myObject = JSONObject("schema:User")
*      ?myObject.Schema --> User
*      myObject.loginName = "vespina"
*      
* 7. Create a JSON object and import its values from a table row:
*      JSON.declareSchema("Customer","{id:numeric,name:string,balance:numeric,active:boolean}")
*      SELECT customers
*      LOCATE FOR id = 25
*      oCustomer = JSONObject("schema:Customer")
*      oCustomer.Import("customers")
*      ?oCustomer.Id --> 25
*
* 8. Update a data record from a JSON object:
*      oCustomer = JSONObject("schema:Customer")
*      oCUstomer.Id = 25
*      oCUstomer.Name = "VICTOR ESPINA"
*      oCustomer.Balance = 1244.23
*      oCustomer.Active = .T.
*      SELECT customers
*      APPEND BLANK
*      oCustomer.Export("customers")
*      ?id --> 25
*      ?name --> 'VICTOR ESPINA'
*
* 9. Creating an schema instance and initializes with an external source
*      SELECT Users
*      LOCATE FOR id = 25
*      oUser = JSONObject("schema:User", "users")
*      ?oUser.id --> 25
*
* 10. Encode a data cursor:   [2]
*       cCursorData = JSON.encodeCursor("QDATA")
*       USE IN QDATA
*
* 11. Restore a data cursor from JSON string:
*       JSON.parseCursor(cCursorData)
*       SELECT QDATA
*
* 12. Convert an array in a JSON-friendly object:
*       object = JSONArray(@array)
*
* 13. Create a JSON-friendly array object from a JSON string:
*       object = JSONArray("['Red','Yellow','Green']")
*       ?object[1] --> 'Red'
*
* 14. Use a JSON array object to get a JSON representation of an array:
*       object = JSONArray(@array)
*       cJSON = object.ToJSON()
*
* 15. Export the contents of a JSON array object to a VFP array:
*       LOCAL ARRAY myArray[1]
*       object = JSONArray("['Red','Yellow','Green']")
*       object.ToArray(@myArray)
*       ?myArray[1] --> 'Red'
*
* 16. Parsing the result of a URL call in JSON format:
*     object = JSONObject("url:http://weather.yahooapis.com/forecastjson?w=2502265")
*
*
* NOTES:
* [1] JSON schemas is a personal adaptation of the JSON syntax and
*     it is not supported by JSON.org standards.  The idea is to 
*     declare a object "schema" or data structure and then use it
*     to create empty instances that follows the schema properties.
*
*     This allow us, i.e., to declare a "User" schema and use it every time 
*     we need to handle user's data. This way, if we later need to add
*     a new property to User objects, all we have to do is to change
*     the schema and the new property will be available to the entire
*     app. Is important to understand that this is not supossed to 
*     substitute your custom classes... is more like to have the ability
*     to declare and use data structures to represent complex data.
*
*     A schema definition string contains one or more "property:type" pairs
*     separated with comma and enclosed within curly brackets:
*
*     {name:string,fullName:string,age:numeric,dateOfBirth:datetime}
*
*     The recognized data types are:
*      string
*      numeric
*      boolean
*      date
*      datetime
*      array (parsed as a Collection instance)
*
*     You can also declare object properties, by following the same rules:
*   
*     {name:string,fullName:string,personalInfo:{age:numeric,dob:date},password:string}
*
*     this will create an object with the following interface:
*
*     object
*       .name
*       .fullName
*       .personalInfo
*         .age
*         .dob
*       .password
*
*
* [2] Take in consideration that encoding and decoding data cursors can be
*     a very time & CPU consuming tasks. This functions are intended to be
*     used with small data cursors.
*
*
*
* IMPORTANT NOTE:
* Altough this parser follows the general rules for JSON strings as
* described in JSON.org, and because of that it should work for 
* deserializing any JSON-compatible string, the main goal for this
* library is to be used with Foxpro objects. 
*
* DON'T TAKE FOR GRANTED THAT THIS LIBRARY WILL WORK WITH JSON
* STRINGS GENERATED BY OTHER JSON PARSERS, NOR THE JSON STRING
* GENERATED BY THIS LIBRARY SHOULD WORK WITH OTHER JSON PARSERS.
*
* Altough this library should work with any kind of object, it
* contains an special class called JSONObject wich is very
* light (based on EMPTY class) and can be used to create and recreate
* JSON-compatible objects. In most cases, we recomend to use JSONObject
* to represent data objects instead your own clases, unless they are
* base on the EMPTY class.
*
* NOTE ON ARRAY VALUES AND COLLECTION OBJECTS
* JSON.Encode() will accept array-type values or properties but, take on
* consideration that JSON.Parse() will parse this arrays values as 
* Collections. In the same way, object properties that are based on
* Collection class will be encoded as array values.
*
* ***********************************************
* **          I N T E R F A C E S              **
* ***********************************************
*
* -------------------------------------
* jsonHelper Class
* -------------------------------------
* string Version
* collection Schemas
* char stringDelimitator
* bool quotePropertyNames
* bool canonicalNotation
* (object) Parse(string jsonString)
* (int) parseCursor(string jsonString [,string cursorAlias])
* (string) Encode(object Object)
* (string) encodeArray(array arrayValue)
* (string) encodeCursor([string cursorAlias])
* (void) declareSchema(string schemaName, string jsonSchema)
* (bool) isSchema(object objectToVerify, string schemaName)
* (bool) isObject(string jsonString)
* (bool) isArray(string jsonString)
*
* -------------------------------------
* JSONObject Class
* -------------------------------------
* string Schema
* (void) Add(string propertyName, variant propertyValue)
* (object) Add(string propertyName, arrayValue)
* (object) Add(string propertyName, string jsonString)
* (object) addArray(string propertyName)
* (string) ToJSON()
* (void) Parse(string jsonString)
* (void) Import(object | alias)
* (void) Export(object | alias)
* (bool) Is(string schemaName)
*
* -------------------------------------
* JSONArray Class
* -------------------------------------
* int Lines
* int Columns
* (string) TOJSON()
* (int) ToArray(@arrayVar)
*
*
#DEFINE CRLF					CHR(13) + CHR(10)
#DEFINE VFP_NOENCODABLE_PROPS	"-controls-controlcount-objects-parent-baseclass-classlibrary-parentclass-helpcontextid-whatsthishelpid-top-left-width-height-picture-"


*******************************************
** 
**           F U N C T I O N S
**
*******************************************

* JSONStart
* Class loader
PROCEDURE JSONStart
 PUBLIC JSON
 JSON = CREATEOBJECT("jsonHelper")
ENDPROC


* JSONObject
* Quick function to create empty JSON-friendly objects
*
* Usage:
* o = JSONObject()             && Empty object
* o = JSONObject(cMyJSONStr)   && Recreates a object
*
PROCEDURE JSONObject(pcJSON)
 RETURN CREATEOBJECT("JSONObject",pcJSON)
ENDPROC


* JSONArray
* Takes an array an convert it to a JSONArray
PROCEDURE JSONArray(paArray)
 IF PCOUNT() = 1
  RETURN CREATEOBJECT("JSONArray",@paArray)
 ELSE
  RETURN CREATEOBJECT("JSONArray")
 ENDIF
ENDPROC




*******************************************
** 
**             C L A S S E S 
**
*******************************************

* jsonHelper (Class)
* JSON implementation class
*
DEFINE CLASS jsonHelper AS Custom
 *
 Version = "1.5"
 Schemas = NULL
 stringDelimitator = [']
 quotePropertyNames = .F.
 canonicalNotation = .F.
 
 
 * Class constructor
 PROCEDURE Init
  THIS.Schemas = CREATEOBJECT("Collection")
  THIS.declareSchema("Cursor","{name:string, schemax:array, rows:array}")
 ENDPROC
 
 * Property Accesors
 PROCEDURE canonicalNotation_Assign(vNewVal)
  THIS.canonicalNotation = m.vNewVal
  IF m.vNewVal
   THIS.quotePropertyNames = .T.
   THIS.stringDelimitator = ["]
  ELSE
   THIS.quotePropertyNames = .F.
   THIS.stringDelimitator = [']  
  ENDIF 
 ENDPROC
 
 
 *******************************************
 **       P U B L I C   M E T H O D S 
 *******************************************
 
 * Parse
 * Takes a JSON string and returns the original object
 PROCEDURE Parse(pcJSON)
	 *
	 LOCAL oObjects, i, oResult, lIsArray, lIsVFP, cVFPClass
	 STORE .F. TO lIsArray, lIsVFP

     DO CASE
        CASE LEFT(pcJSON,1) = "["
             lISArray = .T.
             oResult = JSONArray()
             
        CASE LEFT(pcJSON,5) == "{vfp:"
			 LOCAL oVFPInfo
			 oVFPInfo = JSON.Parse(STRT(LEFT(pcJSON,AT("}",pcJSON)),"vfp:true,",""))
			 pcJSON = SUBSTR(pcJSON,AT("{",pcJSON,2))
			 oResult = CREATEOBJECT(oVFPInfo.Class)
			 lIsVFP = .T.
			
	    OTHERWISE
	         oResult = CREATEOBJECT("Empty")		 
	 ENDCASE
	 pcJSON = SUBSTR(pcJSON,2,LEN(pcJSON) - 2) 
	 
	 LOCAL oPairs, j, cPair, cProp, cValue, uValue, oObj, cObj, nBlockCount, nSep
	 oObjects = THIS._Split(pcJSON)
	 FOR i = 1 TO oObjects.Count
	  *
	  cObj = oObjects.Item[i]
	  IF EMPTY(cObj)
	   LOOP
	  ENDIF
	  
	  IF lIsArray AND THIS.IsObject(cObj)
	   oResult.Add(THIS.Parse(cObj))
	   LOOP
	  ENDIF

	  oPairs = THIS._Split(cObj)
	  oObj = CREATEOBJECT("Empty")
	  FOR j = 1 TO oPairs.Count
	   *
	   cPair = ALLTRIM(oPairs.Item[j])
	   IF lIsArray
	    cValue = cPair
	   ELSE
	    nSep = AT(":",cPair)
	    cProp = CHRTRAN(LEFT(cPair, nSep - 1),["'],[])
	    cValue = ALLTRIM(SUBSTR(cPair, nSep + 1))
	   ENDIF
	   
	   DO CASE
	      CASE LEFT(cValue,1) $ ['"]    && String value
	           uValue = THIS._decodeString( LEFT(SUBSTR(cValue,2),LEN(cValue) - 2) )
	           
	      CASE LEFT(cValue,1) = [@]   && Date/DateTime
	           cValue = SUBSTR(cValue,2)
	           IF LEN(cValue) = 8
	            uValue = CTOD(TRANSFORM(cValue,"@R ^9999-99-99"))
	           ELSE
	            uValue = CTOT(TRANSFORM(cValue,"@R ^9999-99-99 99:99:99"))
	           ENDIF
	      
	      CASE INLIST(cValue,"true","false")  && Boolean value
	           uValue = (cValue == "true")
	         
	      CASE cValue == "null"   && Null value
	           uValue = NULL
	            
	      CASE LEFT(cValue,1) = [{]   && Object
	           uValue = THIS.Parse(cValue)
	           
	      CASE LEFT(cValue,1) = "["   && Array
	           uValue = THIS.Parse(cValue)
	 
	      CASE INLIST(LOWER(cValue),"string","numeric","date","datetime","boolean","array")  && Schema
	           DO CASE
	              CASE cValue == "string"
	                   uValue = ""
	                   
	              CASE cValue == "numeric"
	                   uValue = 0.0
	                   
	              CASE cValue == "date"
	                   uValue = {}
	                   
	              CASE cValue == "datetime"
	                   uValue = {//::}
	                   
	              CASE cValue == "boolean"
	                   uValue = .F.
	                   
	              CASE cValue == "array"
	                   uValue = CREATEOBJECT("Collection")
	           ENDCASE
	           
	      OTHERWISE                   && Numeric value
	           uValue = VAL(STRTRAN(cValue, ".", SET("POINT")))  && JuanPa, Abril 13 2012

	   ENDCASE

       DO CASE
          CASE lIsArray
               oResult.Add(uValue)
               
          CASE lIsVFP
               STORE uValue TO oResult.&cProp
               
          OTHERWISE
	           ADDPROPERTY(oResult,cProp,uValue)
	   ENDCASE
	   *
	  ENDFOR
	  
	  *
	 ENDFOR
	 
	 RETURN oResult
	 *
 ENDPROC
 
 
 * parseCursor
 * Takes a JSON string and recreates the original cursor
 PROCEDURE parseCursor(pcJSON, pcAlias)
	 *
	 * Decode JSON
	 LOCAL oCursor
	 oCursor = JSONObject(pcJSON)	 
	 
	 * Check that object passed is a cursor object
	 IF NOT oCursor.Is("Cursor")
	  RETURN .F.
	 ENDIF
	 
	 * If a custom cursor name was passed, replace original name with the new one
	 LOCAL cCursorAlias
	 cCursorAlias = oCursor.Name
	 IF VARTYPE(pcAlias) = "C"
	  cCursorAlias = pcAlias
	 ENDIF
	 
	 * Get cursor schema. JSON arrays are allways unidimensinal, so we have to 
	 * export the array to a valid VFP structure-array
	 LOCAL ARRAY aSchemaX[1]
	 LOCAL ARRAY aSchema[1]
	 oCursor.Schemax.ToArray(@aSchemax)
	 DIMENSION aSchema[ALEN(aSchemaX,1) / 18,18]
	 ACOPY(aSchemaX, aSchema)
	 RELEASE aSchemaX
	 
	 * Creates cursor
	 SELECT 0
	 CREATE CURSOR (cCursorAlias) FROM ARRAY aSchema
	 
	 * Load cursor data. Sadly, an empty-based object cannot be used
	 * to fill a data record using GATHER NAME. So, we prepare a 
	 * macro-substitution REPLACE to fill each row manually. 
	 IF oCursor.Rows.Count > 0
	  LOCAL oRow, cReplace,i
      cReplace = ""
      FOR i = 1 TO FCOUNT()
       cReplace = cReplace + IIF(i > 1,",","") + FIELD(i) + " WITH oRow." + FIELD(i)
      ENDFOR
      cReplace = "REPLACE " + cReplace
	  FOR EACH oRow IN oCursor.Rows
	   APPEND BLANK
	   &cReplace
	  ENDFOR
	 ENDIF
	 
	 RELEASE oCursor
	 *
 ENDPROC
 
 
 * Encode
 * Takes a object and returns a json representation
 PROCEDURE Encode(poObj)
   	 *
	 LOCAL aProps[1]
	 LOCAL nCount, i, cJSON, cProp, lIsArray, lIsVFP, cVFPClass
	 nCount = AMEMBERS(aProps,poObj,1)   && Get member list
	 lIsVFP = (TYPE("poObj.baseClass")="C")
	 cJSON = "{"
	 FOR i = 1 TO nCount   && Cycle trough members
	  *
	  DO CASE
	     CASE aProps[i,2] = "Property"    && Just process property members
	          cProp = aProps[i,1]
	          IF lISVFP AND "-" + LOWER(cProp) + "-" $ VFP_NOENCODABLE_PROPS
	           LOOP
	          ENDIF
	          IF lISVFP AND LOWER(cProp) == "class"
	           cVFPClass = poObj.Class
	           LOOP
	          ENDIF
	          lIsArray = (TYPE("poObj." + cProp,1) = "A")
	          * Encode the property and add it to the JSON chain
	          IF NOT lISArray
	           cJSON = cJSON + IIF(LEN(cJSON) > 1,",","") + ;
	                   IIF(THIS.quotePropertyNames,THIS.stringDelimitator,"") + ;
	                   LOWER(cProp) + ;
	                   IIF(THIS.quotePropertyNames,THIS.stringDelimitator,"") + ;
	                   ":" + ALLTRIM(THIS._encodeValue(poObj.&cProp))
	          ELSE
	           LOCAL ARRAY aValues[1]
	           ACOPY(poObj.&cProp, aValues)
	           cJSON = cJSON + IIF(LEN(cJSON) > 1,",","") + ;
	                   IIF(THIS.quotePropertyNames,THIS.stringDelimitator,"") + ;
	                   LOWER(cProp) + ;
	                   IIF(THIS.quotePropertyNames,THIS.stringDelimitator,"") + ;
	                   ":" + THIS._encodeValue(@aValues)
	          ENDIF
	  ENDCASE
	  *
	 ENDFOR
	 cJSON = cJSON + "}"
	 
	 IF lISVFP
	  cJSON = "{vfp:true,class:" + THIS.stringDelimitator + cVFPClass + THIS.stringDelimitator + "}" + cJSON
	 ENDIF
	 
	 RETURN cJSON
  	 *
 ENDPROC
 
 
 * encodeCursor
 * Takes a cursor alias and generate a JSON representation of cursor schema & data
 PROCEDURE encodeCursor(pcAlias)
	 *
	 IF PCOUNT() = 0
	  pcAlias = ALIAS()
	 ENDIF
	 
	 LOCAL oCursor,oRow
	 oCursor = JSONObject("schema:Cursor")
	 oCursor.Schema = "Cursor"
	 oCursor.Name = pcAlias
	 
	 LOCAL ARRAY aSchema[1]
	 AFIELDS(aSchema, pcalias)
	 oCursor.Schemax = JSONArray(@aSchema)
	 
	 SELECT (pcAlias)
	 GO TOP
	 SCAN
	  SCATTER NAME oRow MEMO
	  oCursor.Rows.Add(oRow)
	 ENDSCAN
	 
	 RETURN oCursor.ToJSON()
	 *
 ENDPROC
 
 
 * declareSchema
 * Declares an JSON schema
 PROCEDURE declareSchema(pcName, pcSchema)
	 *
	 IF PCOUNT() <> 2
	  THROW "JSON2: JSON.declareSchema: invalid parameter count"
	  RETURN NULL
	 ENDIF
	 
	 THIS.Schemas.Add( pcSchema, LOWER(pcName) )
	 *
 ENDPROC
 
 
 * isSchema
 * Check if the passed object implements an specific schema
 PROCEDURE IsSchema(poRef, pcSchema)
	 *
	 pcSchema = LOWER(pcSchema)
	 
	 * If object implements Is() method, used it
	 IF PEMSTATUS(poRef, "Is", 5)
	  RETURN poRef.Is(pcSchema)
	 ENDIF
	 
	 * Create an instance of the given schema
	 LOCAL oBase
	 oBase = JSONObject("schema:" + pcSchema)
	 
	 * Verify that the passed objects implements all schema's proporties
	 LOCAL ARRAY aProps[1]
	 LOCAL nCount, i, cProp, lIsValid
	 lIsValid = .T.
	 nCount = AMEMBERS(aProps, poRef, 0)
	 FOR i = 1 TO nCount
	  cProp = aProps[i]
	  IF (NOT PEMSTATUS(poRef, cProp, 5)) OR ;
	     (TYPE("poRef." + cProp) = TYPE("oBase." + cProp))
	   lIsValid = .F.
	   EXIT  
	  ENDIF
	 ENDFOR
	 
	 RETURN lIsValid
	 *
 ENDPROC
 
 * isArray
 * Check if the passed JSON string corresponds to an array
 PROCEDURE isArray(pcString)
  RETURN VARTYPE(pcString)="C" AND LEFT(pcString,1)="[" AND RIGHT(pcString,1)="]"
 ENDPROC

 * isObject
 * Check if the passed JSON string corresponds to an object
 PROCEDURE isObject(pcString)
  RETURN VARTYPE(pcString)="C" AND LEFT(pcString,1)="{" AND RIGHT(pcString,1)="}"
 ENDPROC
 
 
 *******************************************
 **      S U P P O R T   M E T H O D S
 *******************************************

 HIDDEN PROCEDURE _encodeValue(puValue)
  *
  EXTERNAL ARRAY puValue
  
  LOCAL lIsArray, cType, cJSONValue
  lIsArray = (TYPE("puValue",1) = "A")
  cType = VARTYPE(puValue)
  cJSONValue = "null"
  DO CASE
     CASE lIsArray        && Array value
          cJSONValue = "["
          LOCAL i
          FOR i = 1 TO ALEN(puValue,1)
           cJSONValue = cJSONValue + IIF(i>1,",","") + THIS._encodeValue(puValue[i])
          ENDFOR
          cJSONValue = cJSONValue + "]"
     
     CASE cType $ "CM"    && string/char value
          cJSONValue = THIS.stringDelimitator + THIS._encodeString(puValue) + THIS.stringDelimitator
          
     CASE cType $ "NIYF"   && Numeric value
          IF puValue = INT(puValue)
           cJSONValue = ALLTRIM(STR(puValue))
          ELSE
           cJSONValue = CHRTRAN(RTRIM(RTRIM(TRANSFORM(puValue), "0"), SET("POINT")),SET("POINT"), ".")  && JuanPa / Rafel Cano, Abril 13 2012
          ENDIF
                    
     CASE cType = "L"     && boolean value
          cJSONValue = IIF(puValue,"true","false")
          
     CASE cType = "D"     && Date value (foxpro only)
          cJSONValue = [@] + DTOS(puValue)
          
     CASE cType = "T"     && Datetime value (foxpro only)
          cJSONValue = [@] + TTOC(puValue,1)
          
     CASE cType = "O"     && Object value
          DO CASE
             CASE THIS._IsCollection(puValue)
		          LOCAL ARRAY aItems[puValue.Count]
		          LOCAL i
		          FOR i = 1 TO puValue.Count
		           aItems[i] = puValue.Item[i]
		          ENDFOR
		          cJSONValue = THIS._encodeValue(@aItems)
		          RELEASE aItems
             
             CASE PEMSTATUS(puValue,"ToJSON",5)
                  cJSONValue = puValue.toJSON()

             OTHERWISE
		          cJSONValue = THIS.Encode(puValue)             
          ENDCASE
          
     OTHERWISE            && unknown type. Handle it as a string value
          cJSONValue = TRANSFORM(puValue,"")
  ENDCASE

  RETURN cJSONValue
  *
 ENDPROC 
 
 HIDDEN PROCEDURE _Split(pcJSON)
	 *
	 LOCAL nBlockCount,cObj,lOpenQuote,cChar
	 nBlockCount = 0  
	 cObj = pcJSON
	 lOpenQuote = .F.
	 FOR j = 1 TO LEN(cObj)
	   cChar = SUBSTR(cObj, j, 1)
	   DO CASE
	      CASE cChar $ "[{"
	           nBlockCount = nBlockCount + 1
	   
	      CASE cChar $ "]}"
	           nBlockCount = nBLockCount - 1

	      CASE cChar $ THIS.stringDelimitator
	           IF lOpenQuote
	            nBlockCount = nBLockCount - 1
	           ELSE
	            nBlockCount = nBlockCount + 1 
	           ENDIF
	           lOpenQuote = !lOpenQuote
	           
	      CASE cChar = "," AND nBlockCount = 0
	           cObj = STUFF(cObj,j,1,CHR(254))
	   ENDCASE
	 ENDFOR   
	 
	 LOCAL ARRAY aObjects[1]
	 LOCAL nCount, i, oResult
	 oResult = CREATEOBJECT("Collection")
	 nCount = ALINES(aObjects, STRT(cObj,CHR(254),CRLF))
	 FOR i = 1 TO nCount
	  oResult.add(aObjects[i])
	 ENDFOR
	 
	 RETURN oResult
	 *
 ENDPROC
 
 HIDDEN PROCEDURE _isCollection(poObj)
  RETURN VARTYPE(poObj)="O" AND PEMSTATUS(poObj,"Count",5) AND PEMSTATUS(poObj,"Item",5)
 ENDPROC

 HIDDEN PROCEDURE _encodeString(pcString)
  pcString = STRT(pcString, CHR(13), "%CR%")
  pcString = STRT(pcString, CHR(10), "%LF%")  
  pcString = STRT(pcString, CHR(9), [%TAB%])
  pcString = STRT(pcString, ['], [%SINGLEQUOTE%])
  pcString = STRT(pcString, ["], [%DOUBLEQUOTE%])
  RETURN pcString
 ENDPROC
 
 HIDDEN PROCEDURE _decodeString(pcString)
  pcString = STRT(pcString, [%CR%], CHR(13))
  pcString = STRT(pcString, [%LF%], CHR(10))
  pcString = STRT(pcString, [%TAB%], CHR(9))
  pcString = STRT(pcString, [%SINGLEQUOTE%], ['])
  pcString = STRT(pcString, [%DOUBLEQUOTE%], ["])
  RETURN pcString
 ENDPROC
 *
ENDDEFINE



* JSONObject
* Helper class to create JSON-friendly objects
*
DEFINE CLASS JSONObject AS Custom
 *
 Buff = NULL
 Schema = ""
 Url = ""
 
 * Class constructor. If a JSON string is passed, it recreate
 * the object from it automatically
 PROCEDURE Init(pcJSON, puSource)
  *
  THIS.Buff = CREATEOBJECT("Empty")
  
  * If no JSON string passed, ends here
  IF VARTYPE(pcJSON) <> "C"
   RETURN
  ENDIF
  
  DO CASE
		  * If a schema was indicated, create the object from the 
		  * given schema; otherwise, create the object from the
		  * JSON string passed
     CASE LEFT(pcJSON,7) == "schema:"
		  LOCAL cSchema
		  cSchema = LOWER(SUBSTR(pcJSON,8))
		  IF JSON.Schemas.getKey(cSchema) > 0
		   THIS.parseFromSchema(cSchema)
		  ELSE
		   THROW "qdfoxJSON: Schema " + cSchema + " has not been declared"
		  ENDIF
		  
		  
		  * If we received and URL, get the response and parse it
     CASE LEFT(pcJSON,4) == "url:"
          THIS.parseFromURL( SUBSTR(pcJSON,5) )
          
          
          * Process a normal JSON string
     OTHERWISE
          THIS.Parse(pcJSON)
  ENDCASE
  
  * If a data source was passed, import it 
  IF VARTYPE(puSource) $ "OC"
    THIS.Import(puSource)
  ENDIF
  *
 ENDPROC
 
 
 * THIS Accessor
 * Returns the appropiate reference base on the requested member
 PROCEDURE THIS_Access(cMember)
  IF LOWER(cMember)<>"buff" AND PEMSTATUS(THIS.Buff, cMember, 5)
   RETURN THIS.Buff
  ELSE
   RETURN THIS
  ENDIF
 ENDPROC

 
 * Add
 * Add a new property to the object
 PROCEDURE Add(pcProp, puValue)
  EXTERNAL ARRAY puValue
  DO CASE
     CASE TYPE("puValue",1) = "A"
          LOCAL oArray,i
          oArray = THIS.addArray(pcProp)
          FOR i = 1 TO ALEN(puValue,1)
           oArray.Add(puValue[i])
          ENDFOR
          RETURN oArray
     
     CASE JSON.isObject(puValue)
          ADDPROPERTY(THIS.Buff,pcProp,JSONObject(puValue))
          RETURN THIS.Buff.&pcProp
     
     OTHERWISE
          ADDPROPERTY(THIS.Buff, pcProp, puValue)
  ENDCASE
 ENDPROC
 
 * addArray
 * Add a new array property to the object
 PROCEDURE addArray(pcProp, pcValues)
  IF VARTYPE(pcValues) <> "C"
   ADDPROPERTY(THIS.Buff, pcProp, CREATEOBJECT("Collection"))
  ELSE
   ADDPROPERTY(THIS.Buff, pcProp, JSONDecode("[" + pcValues + "]"))
  ENDIF
  RETURN THIS.Buff.&pcProp
 ENDPROC
 
 * ToJSON
 * Return a JSON string representing the object data
 PROCEDURE ToJSON
  RETURN JSON.Encode(THIS.Buff)
 ENDPROC
 
 * Parse
 * Take a JSON string and recover the object data from it
 PROCEDURE Parse(pcJSON)
  THIS.Buff = JSON.Parse(pcJSON)
  IF PEMSTATUS(THIS.Buff,"JSONSchema",5)
   THIS.Schema = THIS.Buff.JSONSchema
  ENDIF
 ENDPROC
 
 * parseFromSchema
 * Create and empty object from a declared schema
 PROCEDURE parseFromSchema(pcSchema)
  pcSchema = LOWER(pcSchema)
  THIS.Buff = JSON.Parse( JSON.Schemas.Item[pcSchema] )
  ADDPROPERTY(THIS.Buff,"JSONSchema",pcSchema)
  THIS.Schema = pcSchema
 ENDPROC
 
 * parseFromURL
 PROCEDURE parseFromURL(pcURL)
  THIS.Buff = JSON.Parse( GetURL(pcURL) )
  THIS.Url = pcURL
 ENDPROC
 
 * Import
 * Import object's properties from an object or alias
 PROCEDURE Import(puSource)
  DO CASE
     CASE VARTYPE(puSource) = "O"  && Object
          LOCAL ARRAY aProps[1]
          LOCAL nCount, i, cProp
          nCount = AMEMBERS(puSource,0)
          FOR i = 1 TO nCount
           cProp = aProps[i]
           IF PEMSTATUS(THIS.Buff,cProp,5)
            STORE EVALUATE("puSource." + cProp) TO ("THIS.Buff." + cProp)
           ENDIF
          ENDFOR
     
     CASE VARTYPE(puSource) = "C" AND USED(puSource) && Alias
          LOCAL i,cProp
          FOR i = 1 TO FCOUNT(puSource)
           cProp = FIELD(i, puSource)
           IF PEMSTATUS(THIS.Buff,cProp,5)
            STORE EVALUATE("puSource." + cProp) TO ("THIS.Buff." + cProp)
           ENDIF
          ENDFOR
  ENDCASE
 ENDPROC
 
 
 * Export
 * Export object's properties value to a given object or alias
 PROCEDURE Export(puTarget)
  DO CASE
     CASE VARTYPE(puTarget) = "O"  && Object
          LOCAL ARRAY aProps[1]
          LOCAL nCount, i, cProp
          nCount = AMEMBERS(puTarget,0)
          FOR i = 1 TO nCount
           cProp = aProps[i]
           IF PEMSTATUS(THIS.Buff,cProp,5)
            STORE EVALUATE("THIS.Buff." + cProp) TO ("puTarget." + cProp)
           ENDIF
          ENDFOR
     
     CASE VARTYPE(puTarget) = "C" AND USED(puTarget) && Alias
          LOCAL i,cProp
          SELECT (puTarget)
          FOR i = 1 TO FCOUNT()
           cProp = FIELD(i)
           IF PEMSTATUS(THIS.Buff,cProp,5)
            REPLACE (cProp) WITH EVALUATE("THIS.Buff." + cProp)
           ENDIF
          ENDFOR
  ENDCASE
 ENDPROC
 
 
 * Is
 * Check if the object implements the given schema
 PROCEDURE Is(pcSchema)
  RETURN (THIS.Schema == LOWER(pcSchema))
 ENDPROC
 
 * Clone
 * Crea una copia del objeto y la devuelve
 *
 PROCEDURE Clone
  RETURN JSONObject(THIS.ToJSON())
 ENDPROC
 *
ENDDEFINE


* JSONArray (Class)
* Represents an array
DEFINE CLASS JSONArray AS Collection
 *
 Lines = 0
 Columns = 0
 
 PROCEDURE Init(paArray)
  DO CASE 
     CASE PCOUNT() = 0
          THIS.Lines = 0
          THIS.Columns = 1
     
     CASE TYPE("paArray",1) = "A"
          LOCAL uItem
          THIS.Lines = ALEN(paArray,1)
          THIS.Columns = ALEN(paArray,2)
		  FOR EACH uItem IN paArray
		   THIS.Add(uItem)
		  ENDFOR
		  
	 CASE THIS._isArray(paArray)
	      LOCAL oItems, uItem
	      oItems = JSON.decodeArray(paArray)
	      THIS.Lines = oItems.Count
	      THIS.Columns = 1
	      FOR EACH uItem IN oItems
	       THIS.Add(uItem)
	      ENDFOR
	      
	 CASE THIS._isCollection(paArray)
	      LOCAL uItem
	      THIS.Lines = paArray.Count
	      THIS.Columns = 1
	      FOR EACH uItem IN paArray
	       THIS.Add(uItem)
	      ENDFOR
  ENDCASE
 ENDPROC
 
 PROCEDURE ToJSON()
  RETURN JSON.encodeArray(THIS)
 ENDPROC
 
 PROCEDURE ToArray(paArray)
  LOCAL nRows,nCols
  nRows = IIF(THIS.Lines > 0, THIS.Lines, THIS.Count)
  nCols = IIF(THIS.Columns > 0, THIS.Columns, 1)
  DIMENSION paArray[nRows,nCols]
  LOCAL uItem, i
  FOR i = 1 TO THIS.COunt
   paArray[i] = THIS.Item[i]
  ENDFOR
  RETURN THIS.Count
 ENDPROC
 
 HIDDEN PROCEDURE _isArray(puValue)
  RETURN (VARTYPE(puValue)="C" AND LEFT(puValue,1) = "[" AND RIGHT(puValue,1)="]")
 ENDPROC
 
 HIDDEN PROCEDURE _isCollection(puValue)
  RETURN (VARTYPE(puValue) = "O" AND PEMSTATUS(puValue,"BaseClass",5) AND LOWER(puValue.baseClass == "collection"))
 ENDPROC
 
 *
ENDDEFINE





*******************************************
** 
**       O L D   F U N C T I O N S
**
**   (For compatibility with verson 1.0)
**
*******************************************

PROCEDURE JSONEncode(poObj)
 RETURN JSON.Encode(poObj)
ENDPROC

PROCEDURE JSONEncodeCursor(pcAlias)
 IF PCOUNT() = 1
  RETURN JSON.Encode(pcAlias)
 ELSE
  RETURN JSON.Encode()
 ENDIF
ENDPROC

PROCEDURE JSONDecodeCursor(pcJSONString, pcAlias)
 IF PCOUNT() = 2
  RETURN JSON.parseCursor(pcJSONString, pcAlias)
 ELSE
  RETURN JSON.parseCursor(pcJSONString)
 ENDIF 
ENDPROC

PROCEDURE JSONDecode(pcJSON)
 RETURN JSON.Parse(pcJSON)
ENDPROC

PROCEDURE JSONDeclareSchema(pcNAme, pcSchema)
 RETURN JSON.declareSchema(pcName, pcSchema)
ENDPROC

PROCEDURE JSONIsSchema(poRef, pcSchema)
 RETURN JSON.isSchema(poRef, pcSchema)
ENDPROC




*******************************************
** 
**    S U P P O R T   F U N C T I O N S
**
*******************************************

*************************************************
**
** GETURL.PRG
** Returns the contains of any given URL
**
** Version: 1.0
**
** Author: Victor Espina (vespinas@cantv.net)
**         Walter Valle (wvalle@develcomp.com)
**         (based on original source code from Pablo Almunia)
*
** Date: August 20, 2003
**
**
** Syntax:
** cData = GetURL(pcURL[,plVerbose])
**
** Where:
** cData	 Contents (text or binary) of requested URL.
** pcURL	 URL of the requested resource or file. If an
**           error occurs, a empty string will be returned.
** plVerbose Optional. If setted to True, progress info
**			 will be shown.
**
** Example:
** cHTML=GetURL("http://www.portalfox.com")
**
**************************************************
PROCEDURE GetURL
LPARAMETER pcURL,plVerbose
 *
 *-- Se definen las funciones API necesarias
 *
 #DEFINE INTERNET_OPEN_TYPE_PRECONFIG     0
 DECLARE LONG GetLastError IN WIN32API
 DECLARE INTEGER InternetCloseHandle IN "wininet.dll" ;
	LONG hInet
 DECLARE LONG InternetOpen IN "wininet.dll" ;
  STRING   lpszAgent, ;
  LONG     dwAccessType, ;
  STRING   lpszProxyName, ;
  STRING   lpszProxyBypass, ;
  LONG     dwFlags
 DECLARE LONG InternetOpenUrl IN "wininet.dll" ;
    LONG    hInet, ;
 	STRING  lpszUrl, ;
	STRING  lpszHeaders, ;
    LONG    dwHeadersLength, ;
    LONG    dwFlags, ;
    LONG    dwContext
 DECLARE LONG InternetReadFile IN "wininet.dll" ;
	LONG     hFtpSession, ;
	STRING  @lpBuffer, ;
	LONG     dwNumberOfBytesToRead, ;
	LONG    @lpNumberOfBytesRead
	
	
 *-- Se establece la conexiÛn con internet
 *
 IF plVerbose
  WAIT "Opening Internet connection..." WINDOW NOWAIT
 ENDIF
 
 LOCAL nInetHnd
 nInetHnd = InternetOpen("GETURL",INTERNET_OPEN_TYPE_PRECONFIG,"","",0)
 IF nInetHnd = 0
  RETURN ""
 ENDIF
 
 
 *-- Se establece la conexiÛn con el recurso
 *
 IF plVerbose
  WAIT "Opening connection to URL..." WINDOW NOWAIT
 ENDIF
 
 LOCAL nURLHnd
 nURLHnd = InternetOpenUrl(nInetHnd,pcURL,NULL,0,0,0)
 IF nURLHnd = 0
  InternetCloseHandle( nInetHnd )
  RETURN ""
 ENDIF


 *-- Se lee el contenido del recurso
 *
 LOCAL cURLData,cBuffer,nBytesReceived,nBufferSize
 cURLData=""
 cBuffer=""
 nBytesReceived=0
 nBufferSize=0

 DO WHILE .T.
  *
  *-- Se inicializa el buffer de lectura (bloques de 2 Kb)
  cBuffer=REPLICATE(CHR(0),2048)
  
  *-- Se lee el siguiente bloque
  InternetReadFile(nURLHnd,@cBuffer,LEN(cBuffer),@nBufferSize)
  IF nBufferSize = 0
   EXIT
  ENDIF
  
  *-- Se acumula el bloque en el buffer de datos
  cURLData=cURLData + SUBSTR(cBuffer,1,nBufferSize)
  nBytesReceived=nBytesReceived + nBufferSize
  
  IF plVerbose
   WAIT WINDOW ALLTRIM(TRANSFORM(INT(nBytesReceived / 1024),"999,999")) + " Kb received..." NOWAIT
  ENDIF
  *
 ENDDO
 IF plVerbose
  WAIT CLEAR
 ENDIF

 
 *-- Se cierra la conexiÛn a Internet
 *
 InternetCloseHandle( nInetHnd )

 *-- Se devuelve el contenido del URL
 *
 RETURN cURLData
 *
ENDPROC

*!*	Procedure transentoch
*!*	    Parameters trans_str,Type
*!*	    If Vartype(trans_str)<>"C"
*!*	        Return ""
*!*	    Else
*!*	 
*!*	    Endif
*!*	 
*!*	    If Vartype(Type)<>"N"
*!*	        Type=1
*!*	    Else
*!*	        If !Inlist(Type,1,2)
*!*	            Type=1
*!*	        Endif
*!*	    Endif
*!*	    Private paratemp
*!*	 
*!*	    If Type=1
*!*	        paratemp=Chrtranc(Strconv(trans_str,2),"abcdefghijklmnopqrstuvwxyz"+Upper("abcdefghijklmnopqrstuvwxyz")+" ,./?<>:;'!@#$%^&*()_-+=|\1234567890"+'"',"")
*!*	        trans_str=Chrtranc(trans_str,paratemp,"")
*!*	    Else
*!*	        trans_str=Chrtranc(Strconv(trans_str,2),"abcdefghijklmnopqrstuvwxyz"+Upper("abcdefghijklmnopqrstuvwxyz")+'@#^&*()_-+=|\<>"',"")
*!*	    Endif
*!*	    trans_str=Alltrim(trans_str)
*!*	    If Empty(trans_str)
*!*	        Return ""
*!*	    Endif
*!*	 
*!*	    Private lcgettempstr
*!*	    If Type=1
*!*	        lcgettempstr = Strtran(Gethttp('http://translate.google.cn/translate_a/t?client=t&text='+trans_str+'&sl=auto&tl=zh-CN&pc=0'),Chr(0)," ")
*!*	        Private temp_ret_str
*!*	        If Type=1
*!*	            temp_ret_str=Substr(lcgettempstr,At('°∞°±',lcgettempstr,1)+4, At('°∞°±',lcgettempstr,2) -At('°∞°±',lcgettempstr,1)-4)
*!*	            If Empty(temp_ret_str)
*!*	                temp_ret_str=Substr(lcgettempstr,At('"trans":"',lcgettempstr,1)+9, At('","orig"',lcgettempstr,1) -At('"trans":"',lcgettempstr,1)-9)
*!*	            Endif
*!*	        Else
*!*	            temp_ret_str=Substr(lcgettempstr,At('°∞°±',lcgettempstr,3)+4, At('°∞°±',lcgettempstr,4) -At('°∞°±',lcgettempstr,3)-4)
*!*	            If Empty(temp_ret_str)
*!*	                temp_ret_str=Substr(lcgettempstr,At('"translit":"',lcgettempstr,1)+12, At('"}]',lcgettempstr,1) -At('"translit":"',lcgettempstr,1)-12)
*!*	            Endif
*!*	        Endif
*!*	        Return temp_ret_str
*!*	    Else
*!*	        *lcgettempstr = Strtran(Gethttp('http://translate.google.cn/translate_a/t?client=t&text='+trans_str+'&sl=zh-CN&tl=en&pc=0'),Chr(0)," ")
*!*	        Local lcRemoteUrl,lcRemoteFile,lcLocalhtm,lcLocalFile
*!*	        Declare Integer DeleteUrlCacheEntry In Wininet.Dll String szUrl
*!*	        Declare Integer URLDownloadToFile In urlmon.Dll Integer pCaller,String szURL,String szFileName,Integer dwReserved,Integer lpfnCB
*!*	        *--œ¬‘ÿÕ¯“≥
*!*	        lcRemoteUrl='http://translate.google.cn/translate_a/t?client=t&text='+trans_str+'&sl=zh-CN&tl=en&pc=0'
*!*	        lcLocalhtm="c:\zhtoen.txt"
*!*	        =DeleteUrlCacheEntry(lcRemoteUrl)    &&«Â¿Ìª∫¥Ê£¨’‚ ± µ ±À¢–¬µƒ ˝æ› ±∫‹”–”√°£
*!*	        If URLDownloadToFile(0,lcRemoteUrl,lcLocalhtm,0,0)=0
*!*	            lcZhToEnStr=Filetostr(lcLocalhtm)
*!*	            Erase (lcLocalhtm)
*!*	            Return Strextract(lcZhToEnStr,["],["],5)
*!*	        Else
*!*	            Messagebox("ªÒ»°Õ¯¬Á–≈œ¢ ß∞‹£°",48,"–≈œ¢Ã· æ")
*!*	            Return ""
*!*	        Endif
*!*	    Endif
*!*	Endproc
*!*	Procedure Gethttp
*!*	    Parameters lcurl
*!*	    Declare Integer InternetOpen In wininet String, Integer, String, String, String
*!*	    Declare Integer InternetCloseHandle In wininet Integer
*!*	    Declare Integer InternetOpenUrl In wininet Integer, String, String, Integer, Integer, Integer
*!*	    Declare Integer InternetReadFile In wininet Integer, String @, Integer, Integer @
*!*	    Private hopen,lcgestr
*!*	    lcgestr = ""
*!*	    hopen = internetopen("vfp 6.0",1,0,0,0)
*!*	    If hopen = 0
*!*	        Messagebox("±æª˙ Dll ∫Ø ˝ø‚Œﬁ–ß£°",16,"–≈œ¢Ã· æ")
*!*	    Else
*!*	        Private hfile
*!*	        hfile = InternetOpenUrl(hopen,lcurl,"",0,16,0)
*!*	        If hfile <> 0
*!*	            Private lntotalbytesread,lnbytesread,lcbuffer
*!*	            lntotalbytesread = 0
*!*	            Do While .T.
*!*	                lcbuffer = Replicate(Chr(0),4096)
*!*	                lnbytesread = 0
*!*	                If InternetReadFile(hfile,@lcbuffer,4096,@lnbytesread) = 1
*!*	                    lcgestr = lcgestr+lcbuffer
*!*	                    If lnbytesread = 0
*!*	                        Exit
*!*	                    Endif
*!*	                    lntotalbytesread = lntotalbytesread+lnbytesread
*!*	                Else
*!*	                    Exit
*!*	                Endif
*!*	            Enddo
*!*	            = InternetCloseHandle(hfile)
*!*	        Else
*!*	            Messagebox("ªÒ»°Õ¯¬Á–≈œ¢ ß∞‹£°",48,"–≈œ¢Ã· æ")
*!*	        Endif
*!*	        = InternetCloseHandle(hopen)
*!*	    Endif
*!*	    Clear Dlls
*!*	    Return lcgestr
*!*	Endproc
	FUNCTION translate(lcText)
		LOCAL lcHttp AS MSXML2.XMLHTTP
		LOCAL lcRequest AS String
		ccsd=lcText
		lcHttp = CREATEOBJECT("MSXML2.XMLHTTP")
		*lcRequest = 'http://translate.google.cn/translate_a/t?client=t&sl='+F1+'&tl='+F3+'&hl=zh-CN&sc=2&ie=UTF-8&pc=1&oc=1&otf=1&oe=UTF-8&ssel=0&tsel=0'
*!*			DO CASE 
*!*				CASE f1='en'
*!*					lcRequest = 'http://translate.google.cn/translate_a/single?client=t&sl='+F1+'&tl='+F3+'&hl=zh-CN&dt=bd&dt=ex&dt=ld&dt=md&dt=qca&dt=rw&dt=rm&dt=ss&dt=t&dt=at&ie=UTF-8&oe=UTF-8&source=btn&srcrom=0&ssel=0&tsel=0&kc=0&tk=520947|884150'
*!*					lcRequest=lcRequest +'&q='+lcText
*!*				case f1='fr'
				*=SYS(3101,65001)=SYS(3101,936)
				lcRequest = 'http://translate.google.cn/translate_a/single?client=t&sl='+f1+'&tl='+F3+'&hl=zh-CN&dt=bd&dt=ex&dt=ld&dt=md&dt=qca&dt=rw&dt=rm&dt=ss&dt=t&dt=at&ie=UTF-8&oe=UTF-8&q='+urlencode(STRCONV(FILETOSTR("c:\UTF8∏Ò Ω.txt"),14))&& +' HTTP/1.1'&&&source=btn&ssel=0&tsel=0&kc=0tk=520984|411400
*lcRequest = 'http://translate.google.cn/translate_a/single?client=t&sl=en&tl=zh-CN&hl=zh-CN&dt=at&dt=bd&dt=ex&dt=ld&dt=md&dt=qca&dt=rw&dt=rm&dt=ss&dt=t&ie=UTF-8&oe=UTF-8&otf=1&ssel=0&tsel=0&kc=2&tk=818549.674442&q='+urlencode(STRCONV(FILETOSTR("c:\UTF8∏Ò Ω.txt"),14)) 

				STRTOFILE(lcRequest ,"c:\UTF8∏Ò Ω2.txt")
				*lcRequest=lcRequest +'&q='+STRCONV(FILETOSTR("c:\UTF8∏Ò Ω.txt"),14)
*!*				*	
*!*					&&STRc(lcText,9)  &&				STRCONV(discharge,14) 9
*!*					*
*!*				OTHERWISE 
*!*					lcRequest = 'http://translate.google.cn/translate_a/single?client=t&sl=auto&tl='+F3+'&hl=zh-CN&dt=bd&dt=ex&dt=ld&dt=md&dt=qca&dt=rw&dt=rm&dt=ss&dt=t&dt=at&ie=UTF-8&oe=UTF-8&source=btn&srcrom=0&ssel=0&tsel=0&kc=0&tk=520947|884150'
*!*					lcRequest=lcRequest +'&q='+STRCONV(lcText,9)
*!*			endcase 
        lcHttp.open("GET",lcRequest,.f.)
        *lcHttp.open("GET",FILETOSTR("c:\UTF8∏Ò Ω2.txt"),.f.)
		lcHttp.setRequestHeader("CONTENT-TYPE","application/x-www-form-urlencoded;charset=utf-8")    
		lcHttp.setRequestHeader("User-Agent","Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.0; Trident/5.0)")		
		lcHttp.send()
		lctextl=lcText
		IF lcHttp.status = 200 
			STRTOFILE(lcHttp.responseText,"c:\UTF8∏Ò Ω4.txt")
			P_HRDEPT=STREXTRACT(STRCONV(FILETOSTR("c:\UTF8∏Ò Ω4.txt"),11),'[',']]',1)
			apiStartTags ='["'
			apiEndTags ='","'
			lcText =''
			i2=occurs(apiStartTags ,P_HRDEPT)
			FOR i1=1 TO i2
				lcText = lcText +STREXTRACT(P_HRDEPT,apiStartTags,apiEndTags,i1)
			ENDFOR 	
			lcText=strt(lcText,'\n',CHR(13)+CHR(10))
			
			RELEASE lcHttp 
			RETURN lcText
		ELSE 	
			RELEASE lcHttp 
			xxx1=''
			lcText3=''
			lcText=lctextl
			I1=INT(LEN(lcText)/2)
			IF f3<>'en'
				x1=AT(',',SUBSTR(lcText,i1))
				IF x1=0
					x1=AT(';',SUBSTR(lcText,i1))
				ENDIF 	
				IF x1=0
					x1=AT('.',SUBSTR(lcText,i1))
				ENDIF 	
			ELSE 	
				x1=AT(',',SUBSTR(lcText,i1))
				IF X1=0
					x1=AT('£¨',SUBSTR(lcText,i1))
				ENDIF 
				IF X1=0
					x1=AT('°£',SUBSTR(lcText,i1))
				ENDIF 			
			ENDIF 
			IF x1>0
				lcText1=SUBSTR(lcText,1,i1+x1)
				lcText2=SUBSTR(lcText,i1+x1+1)
				RELEASE lcHttp 

				lcHttp = CREATEOBJECT("MSXML2.XMLHTTP")
				lcRequest1 =lcRequest +'&q='+STRCONV(FILETOSTR("c:\UTF8∏Ò Ω.txt"),14)
				lcRequest1 = 'http://translate.google.cn/translate_a/single?client=t&sl='+f1+'&tl='+F3+'&hl=zh-CN&dt=bd&dt=ex&dt=ld&dt=md&dt=qca&dt=rw&dt=rm&dt=ss&dt=t&dt=at&ie=UTF-8&oe=UTF-8&q='+urlencode(STRCONV(FILETOSTR("c:\UTF8∏Ò Ω.txt"),14)) &&&source=btn&ssel=0&tsel=0&kc=0tk=520984|411400
*lcRequest1 = 'http://translate.google.cn/translate_a/single?client=t&sl=en&tl=zh-CN&hl=zh-CN&dt=at&dt=bd&dt=ex&dt=ld&dt=md&dt=qca&dt=rw&dt=rm&dt=ss&dt=t&ie=UTF-8&oe=UTF-8&otf=1&ssel=0&tsel=0&kc=2&tk=818549.674442&q='+urlencode(STRCONV(FILETOSTR("c:\UTF8∏Ò Ω.txt"),14)) 

		        lcHttp.open("GET",lcRequest1,.f.)
				lcHttp.setRequestHeader("CONTENT-TYPE","application/x-www-form-urlencoded;charset=utf-8")    
				lcHttp.setRequestHeader("User-Agent","Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.0; Trident/5.0)")		
				lcHttp.send()	
				IF lcHttp.status = 200 
					P_HRDEPT=STREXTRACT(lcHttp.responseText,'[',']]',1)
					apiStartTags ='["'
					apiEndTags ='","'
					lcText21 =''
					i2=occurs(apiStartTags ,P_HRDEPT)
					FOR i1=1 TO i2
						lcText21 = lcText21 +STREXTRACT(P_HRDEPT,apiStartTags,apiEndTags,i1)
					ENDFOR 	
					xxx1=lcText21 
				ELSE
				ENDIF 
				WAIT WINDOWS '' NOWAIT TIMEOUT 2
				RELEASE lcHttp 
				lcHttp = CREATEOBJECT("MSXML2.XMLHTTP")

				lcRequest2=lcRequest+lcText2
				lcHttp.setRequestHeader("CONTENT-TYPE","application/x-www-form-urlencoded;charset=utf-8")    
				lcHttp.setRequestHeader("User-Agent","Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.0; Trident/5.0)")		
		        lcHttp.open("GET",lcRequest2,.f.)
				lcHttp.send()			

				IF lcHttp.status = 200 
					P_HRDEPT=STREXTRACT(lcHttp.responseText,'[',']]',1)
					apiStartTags ='["'
					apiEndTags ='","'
					lcText3 =''
					i2=occurs(apiStartTags ,P_HRDEPT)
					FOR i1=1 TO i2
						lcText3 = lcText3 +STREXTRACT(P_HRDEPT,apiStartTags,apiEndTags,i1)
					ENDFOR 	
					lcText3=xxx1+lcText3
					lcText3=strt(lcText3,'\n',CHR(13)+CHR(10))
				ENDIF 
				RELEASE lcHttp 
			ELSE 
				FEND=FEND+1
			ENDIF 
			IF x1=0
				lcText3 =':('
			ENDIF 
			RETURN lcText3
		ENDIF 
	ENDFUNC

	FUNCTION urlEncode
		PARAMETERS tcValue, llNoPlus
		LOCAL lcResult, lcChar, lnSize, lnX
		
		*** Do it in VFP Code
		lcResult=""
 
		FOR lnX=1 to len(tcValue)

		   lcChar = SUBSTR(tcValue,lnX,1)
		   IF ATC(lcChar,"ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789") > 0
		      lcResult=lcResult + lcChar
		      LOOP
		   ENDIF
		   TRY
			   IF lcChar=" " AND !llNoPlus && AND 1=2 && AND  F1<>'÷–Œƒ'&&
			      lcResult = lcResult + "+"
			      LOOP
			   ENDIF
		   CATCH 
		   ENDTRY
		   *** Convert others to Hex equivalents
		   lcResult = lcResult + "%" + RIGHT(transform(ASC(lcChar),"@0"),2)
		ENDFOR
		lcResult=strt(lcResult,'+%20','%20')

		RETURN lcResult
	ENDFUNC
Function URLencode1
PARAMETER pcInStr
*  ' encode Percent signs
*  '        Double Quotes
*  '        CarriageReturn / LineFeeds
LOCAL lcOut, lnI
  lcOut = ''
  for lnI = 1 to len(pcInStr)
    lcCh = Substr(pcInStr,lnI,1)
    if not between( lcCh, chr(33), chr(126) ) ;
       or inlist(lcCh,[+],[%],["],[,],['],[`],[=],[ ],[&])
		lcCh = '%' + RIGHT( tran(asc(lcCh),'@0'), 2 )
    endif
    lcOut = lcOut + lcCh
  endfor
*!*      lcOut = pcInStr
*!*      lcOut = StrTran(lcOut, "+",  "%2B")
*!*      lcOut = StrTran(lcOut, "%",  "%25")
*!*      lcOut = StrTran(lcOut, '"',  "%22")
*!*      lcOut = StrTran(lcOut, ",",  "%2C")
*!*      lcOut = StrTran(lcOut, Chr(13) + Chr(10), "%0D%0A" )
*!*      lcOut = StrTran(lcOut, Chr(13), "%0D")
*!*      lcOut = StrTran(lcOut, Chr(13), "%0A")
RETURN lcOut
ENDFUNC 	
FUNCTION URL2TXT
LPARAMETERS lcURL

LOCAL lcResult
lcResult = lcURL

DO WHILE "%" $ lcResult
  lcResult = STUFF(lcResult, AT("%", lcResult), 3, HEX2TXT(SUBSTR(lcResult, AT("%", lcResult)+1, 2)))
ENDDO

lcResult = STRTRAN(lcResult, "&"+"lt;", "<")
lcResult = STRTRAN(lcResult, "&"+"gt;", ">")
lcResult = STRTRAN(lcResult, "&"+"amp;", "&")
lcResult = STRTRAN(lcResult, "&"+"quot;", '"')

RETURN lcResult
ENDFUNC 
FUNCTION HEX2TXT
LPARAMETERS lcHex

LOCAL lcStr
lcStr = "0h" + lcHex

RETURN "" + &lcStr

ENDFUNC 
FUNCTION ReadCookie(lcUrl, lcCookieName)
    LOCAL lcCookieData, lnLen, lcResult
    lnLen = 4096
    lcCookieData = SPACE(lnLen)
    lcResult = ""
 
    IF InternetGetCookie(lcUrl, lcCookieName, @lcCookieData, @lnLen) <> 0
        lcResult = LEFT(lcCookieData, lnLen-1)
    ELSE
    * 259 = No more data is available
    ENDIF
RETURN lcResult
 
PROCEDURE AddSessionCookie(lcUrl, lcCookieName, lcCookieData)
* Session cookies are stored in memory and can be accessed 
* only by the process that created them.
    = InternetSetCookie(lcUrl, lcCookieName, lcCookieData)
 
PROCEDURE AddPersistentCookie(lcUrl, lcCookieName, lcCookieData, lvExpires)
* Persistent cookies are cookies that have an expiration date. 
* These cookies are stored in the Windows\System directory.
    = InternetSetCookie(lcUrl, lcCookieName,;
        lcCookieData + ";expires=" + toGMTString(lvExpires))
 
PROCEDURE DeleteCookie(lcUrl, lcCookieName)
* To delete a persistent cookie you must set its expiry date 
* to a time that has already expired.
* Usually it keeps staying as a session cookie after being deleted
 
    = AddPersistentCookie(lcUrl, lcCookieName,;
        "", date()-1)
 
FUNCTION toGMTString(ltDate)
* returns datetime formatted as DAY, DD-MMM-YYYY HH:MM:SS GMT
RETURN SUBSTR("SunMonTueWedThuFriSat",;
        (DOW(ltDate,1)-1)*3+1, 3) + ", " +;
    STRTR(STR(Day(ltDate), 2), " ","0") + "-" +;
    SUBSTR("JanFebMarAprMayJunJulAugSepOctNovDec",;
        (MONTH(ltDate)-1)*3+1, 3) + "-" +;
    STR(YEAR(ltDate),4) + " " +;
    STRTR(STR(HOUR(ltDate), 2), " ","0") + ":" +;
    STRTR(STR(MINUTE(ltDate), 2), " ","0") + ":" +;
    STRTR(STR(SEC(ltDate), 2), " ","0") + " GMT"
 
PROCEDURE declare_http
    DECLARE INTEGER InternetGetCookie IN wininet;
        STRING lpszUrlName, STRING lpszCookieName,;
        STRING @lpszCookieData, INTEGER @lpdwSize
 
    DECLARE INTEGER InternetSetCookie IN wininet;
        STRING lpszUrl, STRING lpszCookieName,;
        STRING lpszCookieData
*!*	DO declare_http
*!*	 
*!*	LOCAL lcUrl, lcCookieName, lcCookieData, lnLen
*!*	lcUrl = "http://www.lhb.com/vfp"
*!*	lcCookieName = "user settings"
*!*	lcCookieData = "regular,54,126,-1,0"

FUNCTION mykeybd(Virtual_Key as Integer)
	PRIVATE Virtual_Key &&º¸≈Ã–Èƒ‚÷µ£¨«Î≤Œ‘ƒ¡–±Ì°£
	DECLARE keybd_event IN user32; &&º¸≈Ãƒ£ƒ‚API
	    SHORT bVk,; &&±Ì æ–Èƒ‚º¸÷µ£¨∆‰»°÷µ∑∂ŒßŒ™1-254°£
	    SHORT bScan,; &&∏√÷µŒ™0
	    INTEGER dwFlags,; &&0∞¥œ¬£¨2µØ∆
	    INTEGER dwExtraInfo &&πÿ”⁄≤Ÿ◊˜µƒ∏Ωº”Àµ√˜£¨“ª∞„Œ™0
	DECLARE INTEGER MapVirtualKey IN user32;
	    INTEGER VK,;
	    INTEGER VI
	DECLARE Sleep IN kernel32 INTEGER dwMilliseconds
	= keybd_event(Virtual_Key, MapVirtualKey(Virtual_Key,0), 0, 0)
	sleep(700)&&∞¥º¸—” ±
	= keybd_event(Virtual_Key, MapVirtualKey(Virtual_Key,0), 2, 0)
	ENDFUNC

*!*		xURL = "http://wapmail.10086.cn/index.htm"  && 139” œ‰∂Ã–≈ª˘¥°∞Êµÿ÷∑
*!*		apIE = Createobject("internetExplorer.Application")
*!*		apIE.Visible = .T.   && Ω®“Èµ˜ ‘ ±¥Úø™À¸
*!*		*!*	apIE.FullScreen=.t.

*!*		apIE.Navigate(xURL)
*!*		Do While apIE.busy Or apIE.readystate#4
*!*		Enddo
*!*		apIE.Document.getElementById("ur").Value = "13958356141"   && «Î ‰»Î±√˚ªÚ ÷ª˙∫≈¬Î
*!*		apIE.Document.getElementById("pw").Value = "hongweilu776868"  && «Î ‰»Î” œ‰√‹¬Î
*!*		xURL = "javascript:login1();"
*!*		apIE.Navigate(xURL)
*!*		Do While  apIE.busy Or apIE.readystate#4
*!*		    =Inkey(1)
*!*		Enddo

*!*    2.¥Úø™∑¢∂Ã–≈“≥√Ê
*!*    µ⁄¡˘∏ˆ Item(I) ¡¨Ω” «∑¢ÀÕ∂Ã–≈µƒµÿ÷∑
*!*	XXX=apIE.LocationURL
*!*	*xURL ="http://m.mail.10086.cn/bv12/" + apIE.Document.Links.Item(6).toString  &&'http://m.mail.10086.cn/bv12/sendsms.html?&sid=MTM5Njk0MTc1NTAwMDcyOTkwNDg3MwAA000004&vn=306&vid=&cmd=40'&& 
*!*	xURL ="http://m.mail.10086.cn/bv12/sendsms.html?&sid=" + STREXTRACT(XXX,'sid=','&realVer')+'&vn=306&vid=&cmd=40'
*!*	apIE.Navigate(xURL)
*!*	Do While  apIE.busy Or apIE.readystate#4
*!*	    =Inkey(1)
*!*	Enddo
*!*	*!*    3.◊‘∂ØÃÓ±Ì
*!*	*!*	apIE.Document.All.reciever.setActive()

*!*	*!*	apIE.Document.All.reciever.select()
*!*	apIE.Document.All.reciever.focus()
*!*	*!*	mykeybd(0x1)
*!*	*!*	mykeybd(0xba)
*!*	*!*	apIE.Document.All.reciever.focus()
*!*	*!*	xURL = 'javascript:void(document.all("reciever").value="13958356141;" + Chr(13));'
*!*	*!*	apIE.Navigate(xURL)
*!*	oShell = Createobject("WScript.Shell")
*!*	If oShell.AppActivate(apIE.Document.Title)
*!*	    For I = 1 To 11  && Tab º¸◊ﬂ 52 ¥Œ£¨∂®ŒªµΩ£∫Ω” ’ ÷ª˙¿∏
*!*	        Wait Window Timeout .1 ""
*!*	        oShell.SendKeys("{TAB}")
*!*	    Endfor
*!*	*!*	    oShell.SendKeys("13958356141")  && µÁª∞∫≈∫Û“ª∂®“™∏˙∑÷∫≈
*!*	Endif
*!*	*!*	apIE.Document.All.reciever.Value='13429263487;' + Chr(13)  &&  ‰»Î ÷ª˙∫≈¬Î
*!*	*!*	*!*	*!*	mykeybd(0x1)
*!*	*!*	apIE.Document.All.reciever.Value='13958356141;' + Chr(13)  &&  ‰»Î ÷ª˙∫≈¬Î
*!*	*!*	apIE.Document.All.reciever.focus()

*!*	Xx='13429263487' 
*!*	FOR I=1 TO 11
*!*		CC='0x'+ALLTRIM(STR(VAL(SUBSTR(XX,I,1))+30))
*!*		mykeybd(&CC)
*!*	NEXT
*!*	*!*		mykeybd(0xba)
*!*	 oShell.SendKeys("{TAB}")

*!*	*=Inkey(1)
*!*	apIE.Document.All.content.Value='∂Ã–≈£∫–°“¶œ¬∞‡¡À.'   && ∂Ã–≈ƒ⁄»›
*!*	=Inkey(1)
*!*	apIE.Document.All.content.focus()
*!*	=Inkey(1)
*!*	apIE.Navigate('javascript:sms_send()')  && ∑¢ÀÕ
*!*	*!*	Do While  apIE.busy Or apIE.readystate#4
*!*	*!*	    =Inkey(1)
*!*	*!*	Enddo
*!*	*!*	*4.πÿ±’ IE
*!*	*!*	Wait Window "∞¥»Œ“‚º¸πÿ±’ IE"
*!*	*!*	apIE.Quit()

*!*	*!*	RETURN
PROCEDURE obj2client
LPARAMETERS loObj,lnPosition
LOCAL lnReturn, lnColumn, lnGrdLeft, lnGridLeft, lnLeft, lnNext, lnRight, loNext
IF NOT BETWEEN(lnPosition,2,3)
	RETURN OBJTOCLIENT(loObj,lnPosition)
ENDIF

IF LEFT(VERSION(4),11)='09.00.0000.' AND VAL(GETWORDNUM(VERSION(4),4,'.'))>3504	; && Service Pack 2
	AND LOWER(loObj.BASECLASS)='column'	&&  ÓÎÓÌÍ‡ „Ë‰‡
	DO CASE
		CASE lnPosition=2 && Left
			lnReturn = OBJTOCLIENT(loObj,2) - OBJTOCLIENT(loObj.PARENT,2)
		CASE lnPosition=3 && Width
			lnGridLeft = OBJTOCLIENT(loObj.PARENT,2)
			lnLeft       = OBJTOCLIENT(loObj,2) - lnGridLeft
			IF lnLeft=0
				RETURN 0
			ENDIF
			lnColumn =  VAL(SUBSTR(loObj.NAME,7))
			IF lnColumn =loObj.PARENT.LOCKCOLUMNS
				lnGrdLeft=OBJTOCLIENT(loObj.PARENT,2)
				FOR lnNext= lnColumn +1 TO loObj.PARENT.COLUMNCOUNT
					IF OBJTOCLIENT(loObj.PARENT.COLUMNS(lnNext),2)>lnGrdLeft
						EXIT
					ENDIF
				NEXT
			ELSE
				lnNext = lnColumn +1
			ENDIF
			IF lnNext<=loObj.PARENT.COLUMNCOUNT
				loNext=loObj.PARENT.COLUMNS(lnNext)
				lnRight= OBJTOCLIENT(loNext,2)-loObj.PARENT.LEFT
				IF lnRight>0
					RETURN lnRight - lnLeft -  IIF(lnColumn=loObj.PARENT.LOCKCOLUMNS,2,1)
				ENDIF
			ENDIF
			lnRight= lnGridLeft + loObj.PARENT.WIDTH - IIF(loObj.PARENT.SCROLLBARS>1,SYSMETRIC(15),0) - 1
			RETURN lnRight - lnLeft - IIF(lnColumn=loObj.PARENT.LOCKCOLUMNS,2,1)
	ENDCASE
ELSE
	lnReturn = OBJTOCLIENT(loObj,lnPosition)
ENDIF
IF lnPosition=2 && Left
	DO WHILE NOT UPPER(m.loObj.BASECLASS) == [FORM]
		IF UPPER(m.loObj.BASECLASS) == [PAGE]
			IF m.loObj.PARENT.TABORIENTATION = 2 && Left
				m.lnReturn = m.lnReturn + ;
					m.loObj.PARENT.WIDTH - ;
					m.loObj.PARENT.PAGEWIDTH - ;
					m.loObj.PARENT.BORDERWIDTH * 2
			ELSE
				m.lnReturn = m.lnReturn - 1
			ENDIF
		ENDIF
		m.loObj = m.loObj.PARENT
	ENDDO
ENDIF
RETURN lnReturn


*!*    SHA1 
*!*    Auteur : C.Chenavier 
*!*    Version : 1.00 - 15/11/2004 


FUNCTION SHA1( cMessage ) 

PRIVATE HO, H1, H2, H3, H4 
LOCAL nNbBlocs, nHigh, nLow 

H0 = 0x67452301 
H1 = 0xEFCDAB89 
H2 = 0x98BADCFE 
H3 = 0x10325476 
H4 = 0xC3D2E1F0 

M.nNbBlocs = LEN(M.cMessage) / 64 

M.nLen = LEN(M.cMessage) 
M.nReste = MOD(M.nLen, 64) 
IF M.nReste > 0 OR M.nLen = 0 
   M.nNbBlocs = M.nNbBlocs + 1 
   IF M.nReste > 55 
      M.cMessage = M.cMessage + CHR(2^7) + REPLICATE(CHR(0), (64 - M.nReste) + 55) 
      M.nNbBlocs = M.nNbBlocs + 1 
   ELSE 
      M.cMessage = M.cMessage + CHR(2^7) + REPLICATE(CHR(0), (55 - M.nReste)) 
   ENDIF 
   M.nHigh = (M.nLen*8) / 2^32 
   M.nLow = MOD(M.nLen*8, 2^32) 
   M.cMessage = M.cMessage + CHR(BITAND(BITRSHIFT(M.nHigh, 24), 0xFF)) ;    && 56 
                           + CHR(BITAND(BITRSHIFT(M.nHigh, 16), 0xFF)) ;    && 57 
                           + CHR(BITAND(BITRSHIFT(M.nHigh, 8), 0xFF))  ;    && 58 
                           + CHR(BITAND(M.nHigh, 0xFF)) ;                   && 59 
                           + CHR(BITAND(BITRSHIFT(M.nLow, 24), 0xFF)) ;     && 60 
                           + CHR(BITAND(BITRSHIFT(M.nLow, 16), 0xFF)) ;     && 61 
                           + CHR(BITAND(BITRSHIFT(M.nLow, 8), 0xFF))  ;     && 62 
                           + CHR(BITAND(M.nLow, 0xFF))                      && 63 
ENDIF 

LOCAL i 

FOR I = 1 TO M.nNbBlocs 
    DO SHA1_ProcessBloc WITH SUBSTR(M.cMessage, 1 + 64*(I-1), 64) 
ENDFOR 

RETURN SUBSTR(TRANSFORM(H0,"@0"),3) + ; 
       SUBSTR(TRANSFORM(H1,"@0"),3) + ; 
       SUBSTR(TRANSFORM(H2,"@0"),3) + ; 
       SUBSTR(TRANSFORM(H3,"@0"),3) + ; 
       SUBSTR(TRANSFORM(H4,"@0"),3) 


PROCEDURE SHA1_ProcessBloc 

LPARAMETERS cBloc 

LOCAL I, A, B, C, D, E, nTemp 
LOCAL ARRAY W(80) 

FOR I = 1 TO 16 
    W(I) = BITLSHIFT(ASC(SUBSTR(M.cBloc, (I-1) * 4 + 1, 1)), 24) + ; 
           BITLSHIFT(ASC(SUBSTR(M.cBloc, (I-1) * 4 + 2, 1)), 16) + ; 
           BITLSHIFT(ASC(SUBSTR(M.cBloc, (I-1) * 4 + 3, 1)), 8) + ; 
           ASC(SUBSTR(M.cBloc, (I-1) * 4 + 4, 1)) 
ENDFOR 

FOR I = 17 TO 80 
    W(i) = BitLRotate(1, BITXOR(W(i-3), W(i-8), W(i-14), W(i-16))) 
ENDFOR 

A = H0 
B = H1 
C = H2 
D = H3 
E = H4 

FOR I = 1 TO 20 
    M.nTemp = BitLRotate(5,A) + BITOR(BITAND(B,C), BITAND(BITNOT(B), D)) + ; 
              E + W(i) + 0x5A827999 
    E = D 
    D = C 
    C = BitLRotate(30,B) 
    B = A 
    A = M.nTemp 
ENDFOR 

FOR I = 21 TO 40 
    M.nTemp = BitLRotate(5,A) + BITXOR(B, C, D) + E + W(i) + 0x6ED9EBA1 
    E = D 
    D = C 
    C = BitLRotate(30,B) 
    B = A 
    A = M.nTemp 
ENDFOR 

FOR I = 41 TO 60 
    M.nTemp = BitLRotate(5,A) + BITOR(BITAND(B,C), BITAND(B,D), BITAND(C,D)) + ; 
              E + W(i) + 0x8F1BBCDC 
    E = D 
    D = C 
    C = BitLRotate(30,B) 
    B = A 
    A = M.nTemp 
ENDFOR 

FOR I = 61 TO 80 
    M.nTemp = BitLRotate(5,A) + BITXOR(B, C, D) + E + W(i) + 0xCA62C1D6 
    E = D 
    D = C 
    C = BitLRotate(30,B) 
    B = A 
    A = M.nTemp 
ENDFOR 

H0 = H0 + A 
H1 = H1 + B 
H2 = H2 + C 
H3 = H3 + D 
H4 = H4 + E 

RETURN 

FUNCTION BitLRotate( nBits, nWord ) 

RETURN BITLSHIFT(M.nWord, M.nBits) + BITRSHIFT(M.nWord, (32-(M.nBits)))

* Function:      sha1encoder 
* Description:   Perform an SHA1 encoding on a text parameter 

FUNCTION sha1encoder(lcMessage) 

PRIVATE HO, H1, H2, H3, H4 
LOCAL lnNumberOfBlocks, lnHigh, lnLow 

H0 = 0x67452301 
H1 = 0xEFCDAB89 
H2 = 0x98BADCFE 
H3 = 0x10325476 
H4 = 0xC3D2E1F0 

* Concatenate to the message a "1" followed by as many zeros as necessary 
* to make the length a multiple of 512 with the last 8 bytes storing the length 
* of the message. 

lnLength = LEN(lcMessage) 

* append bits 10000000 
lcMessage = lcMessage + CHR(2^7) 

* add as many 0 bytes as required to have message bit length a multiple of 512 
* with the last 8 bytes being the number of bits in the original message. 
lnRemainder = MOD(LEN(lcMessage), 64) 
IF lnRemainder > 56 
   lcMessage = lcMessage + REPLICATE(CHR(0), (64 - lnRemainder) + 56) 
ELSE 
   lcMessage = lcMessage + REPLICATE(CHR(0), (56 - lnRemainder)) 
ENDIF 
lnHigh = (lnLength*8) / 2^32 
lnLow = MOD(lnLength*8, 2^32) 
lcMessage = lcMessage + CHR(BITAND(BITRSHIFT(lnHigh, 24), 0xFF)) ;    && 56 
   + CHR(BITAND(BITRSHIFT(lnHigh, 16), 0xFF)) ;    && 57 
   + CHR(BITAND(BITRSHIFT(lnHigh, 8), 0xFF))  ;    && 58 
   + CHR(BITAND(lnHigh, 0xFF)) ;                   && 59 
   + CHR(BITAND(BITRSHIFT(lnLow, 24), 0xFF)) ;     && 60 
   + CHR(BITAND(BITRSHIFT(lnLow, 16), 0xFF)) ;     && 61 
   + CHR(BITAND(BITRSHIFT(lnLow, 8), 0xFF))  ;     && 62 
   + CHR(BITAND(lnLow, 0xFF))                      && 63 

lnNumberOfBlocks = LEN(lcMessage) / 64 

LOCAL I 
FOR I = 1 TO lnNumberOfBlocks 
   DO SHA1_ProcessBlock WITH SUBSTR(lcMessage, 1 + 64*(I-1), 64) 
ENDFOR 

lcDigest = SUBSTR(TRANSFORM(H0,"@0"),3) + ; 
   SUBSTR(TRANSFORM(H1,"@0"),3) + ; 
   SUBSTR(TRANSFORM(H2,"@0"),3) + ; 
   SUBSTR(TRANSFORM(H3,"@0"),3) + ; 
   SUBSTR(TRANSFORM(H4,"@0"),3) 

* return the 20 character string for the 40 hex digit message digest. 

lcReturnValue = "" 
FOR i = 1 TO 20 
   lnValue = HexCharToDec(lcDigest, i * 2 - 1) * 16 + HexCharToDec(lcDigest, i * 2) 
   lcReturnValue = lcReturnValue + CHR(lnValue) 
ENDFOR 

RETURN lcReturnValue 

PROCEDURE SHA1_ProcessBlock  &&SHA1 Ω‚¬Î

   LPARAMETERS cBlock 

   LOCAL I, A, B, C, D, E, nTemp 
   LOCAL ARRAY W(80) 

   * For each block of 512 bits, divide the block into 16 words of 32 bits and 
   * assign them to W1, W2... W16. 

   FOR I = 1 TO 16 
      W(I) = Word32Bits(BITLSHIFT(ASC(SUBSTR(cBlock, (I - 1) * 4 + 1, 1)), 24) ; 
         + BITLSHIFT(ASC(SUBSTR(cBlock, (I - 1) * 4 + 2, 1)), 16) ; 
         + BITLSHIFT(ASC(SUBSTR(cBlock, (I - 1) * 4 + 3, 1)), 8) ; 
         + ASC(SUBSTR(cBlock, (I - 1) * 4 + 4, 1))) 
   ENDFOR 

   * For I varying from 17 to 80, one affects the W(I) words in the following way: 
   * W(I) = W(I-3) XOR W(I-8) XOR W(I-14) XOR W(I-16) 

   FOR I = 17 TO 80 
      W(I) = BitLRotate(1, BITXOR(W(I - 3), W(I - 8), W(I - 14), W(I - 16))) 
   ENDFOR 

   A = H0 
   B = H1 
   C = H2 
   D = H3 
   E = H4 

   *For I varying from 1 to 80 and with Sn a left circular shift of N bits, 
   * one carries out following calculations: 

   FOR I = 1 TO 80 
      nTemp = BitLRotate(5, A) + E + W(I) 
      DO CASE 
      CASE I <= 20 
         nTemp = nTemp + BITOR(BITAND(B, C), BITAND(BITNOT(B), D)) + 0x5A827999 
      CASE BETWEEN(I, 21, 40) 
         nTemp = nTemp + BITXOR(B, C, D) + 0x6ED9EBA1 
      CASE BETWEEN(I, 41, 60) 
         nTemp = nTemp + BITOR(BITAND(B, C), BITAND(B, D), BITAND(C, D)) + 0x8F1BBCDC 
      CASE I >= 61 
         nTemp = nTemp + BITXOR(B, C, D) + 0xCA62C1D6 
      ENDCASE 
      nTemp = Word32Bits(nTemp) 

      E = D 
      D = C 
      C = BitLRotate(30, B) 
      B = A 
      A = nTemp 
   ENDFOR 

   H0 = Word32Bits(H0 + A) 
   H1 = Word32Bits(H1 + B) 
   H2 = Word32Bits(H2 + C) 
   H3 = Word32Bits(H3 + D) 
   H4 = Word32Bits(H4 + E) 
RETURN 

FUNCTION BitLRotate(nBits, nWord) 
   RETURN Word32Bits(BITOR(BITLSHIFT(nWord, nBits), BITRSHIFT(nWord, (32 - nBits)))) 
ENDFUNC 

FUNCTION Word32Bits(lnValue) 
   LOCAL ln32Bits 
   ln32Bits = BITAND(lnValue, 2^32 - 1) 
   DO WHILE ln32Bits < 0 
      ln32Bits = ln32Bits + 2^32 
   ENDDO 
   RETURN ln32Bits 
ENDFUNC 

FUNCTION HexCharToDec(lcString, lnPosition) 
   lcChar = SUBSTR(lcString,lnPosition,1) 
   IF BETWEEN(lcChar, '0', '9') 
      RETURN VAL(lcChar) 
   ELSE && BETWEEN(lcChar, 'A', 'F') 
      RETURN ASC(lcChar) - ASC('A') + 10 
   ENDIF 
ENDFUNC

PROCEDURE pdfcreator
LPARA LcFrxName,LcPdfName

DECLARE Sleep IN kernel32 INTEGER
LOCAL lcRepName,lcFileName,lcFolder,oPDFC,lcOldDefaPrint,DefaultPrinter,laf[1],lnCount


lcFolder = JUSTPATH(LcPdfName)   &&ADDBS(JUSTPATH(SYS(16)))
lcRepName = m.lcFolder  + "reporttest.frx"

IF FILE(LcPdfName+'.pdf')
	MESSAGEBOX("≤…π∫µ•[" + LcPdfName+'.PDF]“—æ≠¥Ê‘⁄,±ÿ–Î…æ≥˝',16,"…æ≥˝æ…PDF≤…π∫µ•")
	mkeyid=0
	RETURN
ELSE 
	mkeyid=9	
ENDIF
lcOldDefaPrint = Alltrim(Set('PRINTER', 2))
TRY 
	oPDFC = CREATEOBJECT("PDFCreator.clsPDFCreator","PDFCreator")    &&Ω®¡¢oPDFCŒÔº˛\
CATCH TO oException2
	lcmsg =  "»±…Ÿ“ª∏ˆ«˝∂Ø≥Ã–Ú,µ„ª˜ Û±Í∫Ûœ¬‘ÿ≤¢∞≤◊∞PDFCreator,∞≤◊∞ ±≤ª“™—°‘Ò∞Ê±æ…˝º∂!" 
	WAIT WINDOW AT SROWS() / 2, (SCOLS() - LEN(lcmsg)) / 2 NOCLEAR NOWAIT lcmsg
	oHtml=Createobject("INTERNETEXPLORER.APPLICATION")
	oHtml.Navigate("http://enkj.newhua.com/down/PDFCreator-1_7_3_setup.zip")
	mkeyid=0
	WAIT CLEAR 
	RETURN
ENDTRY
*oPDFC  = CREATEOBJECT("PDFCreator.clsPDFCreator","pdfcreator")
oPDFC.cStart("/NoProcessingAtStartup")
oPDFC.cOption("UseAutosave") = 1
oPDFC.cOption("UseAutosaveDirectory") = 1
oPDFC.cOption("AutosaveFormat") = 0
* 0 = PDF format
* 1 = PNG
* 2 = JPEG
* 3 = BMP
* 4 = PCX
* 5 = TIFF
DefaultPrinter = oPDFC.cDefaultprinter
oPDFC.cDefaultprinter = "pdfcreator"
oPDFC.cClearCache
ReadyState = 0
oPDFC.cOption("AutosaveFilename") =JUSTSTEM(LcPdfName)   && m.lcFileName
oPDFC.cOption("AutosaveDirectory") =JUSTPATH(LcPdfName) && m.lcFolder
oPDFC.cprinterstop=.F.

SET PRINTER TO NAME (oPDFC.cDefaultprinter) && Fix this 
REPORT FORM "reporttest" NOCONSOLE TO PRINTER 


lnCount = 0
DO WHILE ADIR(laf,LcPdfName) = 0 AND m.lnCount <= 40
    sleep(50)
    lnCount = m.lnCount + 1
ENDDO

oPDFC.cDefaultprinter = DefaultPrinter
****************************
* This is the the new line *
****************************
oPDFC.cOption("UseAutosave") = 0
****************************
****************************
oPDFC.cClearCache
RELEASE m.oPDFC
Set Printer To Name (m.lcOldDefaPrint) 
ENDPROC 


PROCEDURE pdfcreator1

LPARA LcFrxName,LcPdfName
 Declare Sleep In Win32API Integer nMilliseconds

IF ADIR(laf,LcPdfName) > 0
	ERASE (LcPdfName)
	IF ADIR(laf,LcPdfName) > 0
		MESSAGEBOX("≤ªƒ‹¥¥Ω®Œƒº˛: " + LcPdfName,16,"«Î…æ≥˝¥Ê‘⁄µƒPDF")
		RETURN
	ENDIF
ENDIF

Escape_wk = ON("escape")
ON ESCAPE tNoWait=.T.
lcOldPrinter = SET("printer",2)
TRY 
	oPDFC = CREATEOBJECT("PDFCreator.clsPDFCreator","PDFCreator")    &&Ω®¡¢oPDFCŒÔº˛\
CATCH TO oException2
	lcmsg =  "»±…Ÿ“ª∏ˆ«˝∂Ø≥Ã–Ú,µ„ª˜ Û±Í∫Ûœ¬‘ÿ≤¢∞≤◊∞PDFCreator,∞≤◊∞ ±≤ª“™—°‘Ò∞Ê±æ…˝º∂!" 
	WAIT WINDOW AT SROWS() / 2, (SCOLS() - LEN(lcmsg)) / 2 NOCLEAR NOWAIT lcmsg
	oHtml=Createobject("INTERNETEXPLORER.APPLICATION")
	oHtml.Navigate("http://enkj.newhua.com/down/PDFCreator-1_7_3_setup.zip")
	WAIT CLEAR 
	RETURN
ENDTRY

WITH oPDFC
    .cStart("/NoProcessingAtStartup")                                                          &&Ü¢Ñ”PDFCreatorÃìîM”°±ÌôC
    *.cVISIBLE=.F.
    .cOption("UseAutosave") = 1
    .cOption("UseAutosaveDirectory") = 1                                                  && «∑Ò π”√◊‘Ñ”±£¥Êµƒ¬∑èΩ
    .cOption("AutosaveFormat") = 0                                                          &&›î≥ˆ≥…0=PDF∏Ò Ω &&AutosaveFormat£∫0=PDF£¨1=PNG£¨2=JPG£¨3=BMP£¨4=PCX£¨5=TIF£¨6=PS£¨ 7=EPS£¨8=TXT£¨9=PDF£¨10=PDF£¨11=PSD£¨12=PCL£¨13=RAW£¨14=SVG
    .cDefaultprinter = "PDFCreator"                                                            &&∞—ÃìîMPDFCreatorÃìîM”°±ÌôC‘O∂®ûÈœµΩyÓA‘O”°±ÌôC
	DefaultPrinter = .cDefaultprinter

    .cClearCache                                                                                         &&«Â≥˝øÏ»°”õëõÛw
    ReadyState = 0
    .cOption("UseAutosaveDirectory")=1
    .cOption("AutosaveFilename") = JUSTSTEM(LcPdfName)                   &&÷∏∂®◊‘Ñ”É¶¥Êµƒôn∞∏√˚∑Q
    .cOption("AutosaveDirectory") = JUSTPATH(LcPdfName)                   &&÷∏∂®◊‘Ñ”É¶¥ÊµƒŸY¡œäA¬∑èΩ
    .cprinterstop=.F.                                                                                     &&‘⁄È_ ºàÃ––¡–”°÷Æ«∞±ÿÌöœ»÷∏∂®cPrinterStopûÈFalse£¨±Ì æ≤ª «Õ£÷π†ÓëB
*    REPORT FORM (LcFrxName) TO PRINTER NOCONSOLE
	SET PRINTER TO NAME (.cDefaultprinter) && Fix this **('PDFCREATOR')
    REPORT FORM "±®±Ì¥Ú”°"  NOCONSOLE TO PRINTER 

	lnCount = 0
	DO WHILE ADIR(laf,LcPdfName ) = 0 AND m.lnCount <= 40
	    sleep(50)
	    lnCount = m.lnCount + 1
	ENDDO
    IF WEXIST('’˝‘⁄¡–”°...')
        MOVE WINDOW ('’˝‘⁄¡–”°...') TO -100,-100
    ENDIF
    ON ESCAPE &Escape_wk.
    SET PRINTER TO NAME (lcOldPrinter)                                               &&å¢Æî«∞VFPÓA‘O”°±ÌôC‘O∂®ªÿ‘≠œµΩyÓA‘O”°±ÌôC
    .cDefaultprinter = lcOldPrinter                                                                &&å¢Æî«∞VFPÓA‘O”°±ÌôC‘O∂®ªÿ‘≠œµΩyÓA‘O”°±ÌôC
	.cOption("UseAutosave") = 0
    .cClearCache

ENDWITH                                                                                                      &&«Â≥˝øÏ»°”õëõÛw
RELEASE oPDFC  

                                                                                         &&·å∑≈oPDFCŒÔº˛
*!*	i=0
*!*	DO WHILE !FILE(LcPdfName)                                                                      &&Ωo“‘ïrÈg±£¥ÊŒƒº˛
*!*	    i=i+1
*!*	    =INKEY(1)
*!*	    IF FILE(LcPdfName) OR i=1000
*!*	        EXIT
*!*	    ELSE
*!*	        LOOP
*!*	    ENDIF
*!*	ENDDO
Set Printer To Name (lcOldPrinter )                                                                ) 
RETURN  FILE(LcPdfName)
ENDPROC 

Function URLdecode
PARAMETER pcInStr
*  ' unencode EVERY %XX
*  ' (keep track of current position so you don't unencode
*  '  a percent that just came out of an URLencoded char
LOCAL I, tStr, tChr, tOut
  tStr = pcInStr
  tOut = ""
  tStr = StrTran(tStr, "+", " ")
  I = 1
  do While I <= Len(tStr)
    If (SubStr(tStr, I, 1) = "%") ;
       And SubStr(tStr, I + 1, 1) $ "0123456789ABCDEF" ;
       And SubStr(tStr, I + 2, 1) $ "0123456789ABCDEF" 
      tChr = (( At( SubStr(tStr, I + 1, 1), "0123456789ABCDEF" )-1) * 16 ) ;
           + (( At( SubStr(tStr, I + 2, 1), "0123456789ABCDEF" )-1)      ) 
      I = I + 2
*03/18/03 Zero's are now allowed.      
      if between(tChr,0,255) && 03/18/03
*      if tChr > 0 and tChr < 255
        tOut = tOut + chr( tChr )
      endif
    else
      tOut = tOut + SubStr(tStr, I, 1)
    EndIf
    I = I + 1
  EndDo
RETURN tOut