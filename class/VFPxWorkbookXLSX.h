#DEFINE CR                               CHR(13)
#DEFINE LF                               CHR(10)
#DEFINE CRLF                             CR+LF
#DEFINE TAB                              CHR(9)
#DEFINE False                            .F.
#DEFINE True                             .T.
#DEFINE FOF_SILENT                       4

#DEFINE DATA_TYPE_NONE                   "X"
#DEFINE DATA_TYPE_DATE                   "D"
#DEFINE DATA_TYPE_DATETIME               "T"
#DEFINE DATA_TYPE_CHAR                   "C"
#DEFINE DATA_TYPE_INT                    "I"
#DEFINE DATA_TYPE_FLOAT                  "N"
#DEFINE DATA_TYPE_CURRENCY               "Y"
#DEFINE DATA_TYPE_GENERAL                "G"
#DEFINE DATA_TYPE_FORMULA                "F"
#DEFINE DATA_TYPE_TIME                   "M"
#DEFINE DATA_TYPE_PERCENT                "P"

#DEFINE BORDER_LEFT                      1
#DEFINE BORDER_RIGHT                     2
#DEFINE BORDER_TOP                       4
#DEFINE BORDER_BOTTOM                    8
#DEFINE BORDER_DIAGONAL_DOWN            16
#DEFINE BORDER_DIAGONAL_UP              32

#DEFINE BORDER_STYLE_NONE				"none"
#DEFINE BORDER_STYLE_THIN				"thin"
#DEFINE BORDER_STYLE_HAIR				"hair"
#DEFINE BORDER_STYLE_DOTTED				"dotted"
#DEFINE BORDER_STYLE_DASHDOTDOT			"dashDotDot"
#DEFINE BORDER_STYLE_DASHDOT			"dashDot"
#DEFINE BORDER_STYLE_DASHED				"dashed"
#DEFINE BORDER_STYLE_MEDIUMDASHDOTDOT	"mediumDashDotDot"
#DEFINE BORDER_STYLE_SLANTDASHDOT		"slantDashDot"
#DEFINE BORDER_STYLE_MEDIUMDASHDOT		"mediumDashDot"
#DEFINE BORDER_STYLE_MEDIUMDASHED		"mediumDashed"
#DEFINE BORDER_STYLE_MEDIUM				"medium"
#DEFINE BORDER_STYLE_THICK				"thick"
#DEFINE BORDER_STYLE_DOUBLE				"double"

#DEFINE CELL_HORIZ_ALIGN_LEFT           "h-left"
#DEFINE CELL_HORIZ_ALIGN_RIGHT          "h-right"
#DEFINE CELL_HORIZ_ALIGN_CENTER         "h-center"
#DEFINE CELL_VERT_ALIGN_TOP             "v-top"
#DEFINE CELL_VERT_ALIGN_BOTTOM          "v-bottom"
#DEFINE CELL_VERT_ALIGN_CENTER          "v-center"

#DEFINE UNDERLINE_SINGLE				"single"
#DEFINE UNDERLINE_DOUBLE				"double"
#DEFINE UNDERLINE_SINGLEACCOUNTING		"singleAccounting"
#DEFINE UNDERLINE_DOUBLEACCOUNTING		"doubleAccounting"
#DEFINE UNDERLINE_NONE					"none"

#DEFINE FONT_VERTICAL_BASELINE			"baseline"
#DEFINE FONT_VERTICAL_SUBSCRIPT			"subscript"
#DEFINE FONT_VERTICAL_SUPERSCRIPT		"superscript"

#DEFINE CELL_FORMAT_INTEGER                     1    && 0
#DEFINE CELL_FORMAT_FLOAT                       2    && 0.00
#DEFINE CELL_FORMAT_COMMA_INTEGER               3    && #,##0
#DEFINE CELL_FORMAT_COMMA_FLOAT                 4    && #,##0.00
#DEFINE CELL_FORMAT_CURRENCY_PAREN              7    && $#,##0.00;($#,##0.00)
#DEFINE CELL_FORMAT_CURRENCY_RED_PAREN          8    && $#,##0.00;[Red]($#,##0.00)
#DEFINE CELL_FORMAT_PERCENT_INTEGER             9    && ###%
#DEFINE CELL_FORMAT_PERCENT_FLOAT              10    && ###.00%
#DEFINE CELL_FORMAT_EXPONENT                   11    && 0.00E+00
#DEFINE CELL_FORMAT_FRACTION_1                 12    && # ?/?
#DEFINE CELL_FORMAT_FRACTION_2                 13    && # ??/??
#DEFINE CELL_FORMAT_DATE_MMDDYY                14    && mm-dd-yy
#DEFINE CELL_FORMAT_DATE_DMMMYY                15    && d-mmm-yy
#DEFINE CELL_FORMAT_DATE_DMMM                  16    && d-mmm
#DEFINE CELL_FORMAT_DATE_MMMYY                 17    && mmm-yy
#DEFINE CELL_FORMAT_TIME_HMMAMPM               18    && h:mm AM/PM
#DEFINE CELL_FORMAT_TIME_HMMSSAMPM             19    && h:mm:ss AM/PM
#DEFINE CELL_FORMAT_TIME_HMM                   20    && h:mm
#DEFINE CELL_FORMAT_TIME_HMMSS                 21    && h:mm:ss
#DEFINE CELL_FORMAT_DATETIME_MDYYHMM           22    && m/d/yy h:mm
#DEFINE CELL_FORMAT_DATETIME_DDMMMYYYY_TTAM    29    && [$-409]dd/mmm/yyyy\ h:mm\ AM/PM;@
#DEFINE CELL_FORMAT_DATETIME_DDMMMYYYY_TT24    30    && dd/mmm/yyyy\ h:mm;@
#DEFINE CELL_FORMAT_DATETIME_MMMDDYYYY_TTAM    31    && [$-409]mmm\ d\,\ yyyy\ h:mm\ AM/PM;@
#DEFINE CELL_FORMAT_DATETIME_MMMDDYYYY_TT24    32    && [$-409]mmm\ d\,\ yyyy\ h:mm;@
#DEFINE CELL_FORMAT_DATETIME_MDYY_TTAM         33    && m/d/yy\ h:mm\ AM/PM;@
#DEFINE CELL_FORMAT_DATETIME_MDYY_TT24         34    && m/d/yy\ h:mm;@
#DEFINE CELL_FORMAT_COMMA_INTEGER_PAREN        37    && #,##0;(#,##0)
#DEFINE CELL_FORMAT_COMMA_INTEGER_RED_PAREN    38    && #,##0;[Red](#,##0)
#DEFINE CELL_FORMAT_COMMA_FLOAT_PAREN          39    && #,##0.00;(#,##0.00)
#DEFINE CELL_FORMAT_COMMA_FLOAT_RED_PAREN      40    && #,##0.00;[Red](#,##0.00)
#DEFINE CELL_FORMAT_TIME_MMSS                  45    && mm:ss
#DEFINE CELL_FORMAT_TIME_H_MMSS                46    && [h]:mm:ss
#DEFINE CELL_FORMAT_CURRENCY_RED              165    && $#,##0.00;[Red]$#,##0.00
