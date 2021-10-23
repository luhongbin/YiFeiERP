# YiFeiERP

1.基于C/S架构的制造型企业的管理系统 首版开发起始于上个世纪80年代 当时DBASEII 之后FOXBASE用于企业管理的数据处理,使用环境是PC DOS

微软推出WINDOWS后 开发工具VFP推出~软件升级为WINDOWS版本 相关积累的子程序 一并升级 满足新系统需求

这个平台积累了 数十家企业 不同行业的经验 都是基于 这个框架 开发的 涉及 供产销人财物的 方方面面

2.YiFeiERP这个开源作品 也是基于上述框架 对鼎捷的易飞ERP进行外挂 已经有多年 实际应用经验~主要是完善 补充易飞ERP(现在的T100)功能 实现对企业更有效的管控

比如自研的APS,把产能\人力资源\物料整体分析后 业务员下单前 进行判断 不满足条件 无法下单~会提供最早交货时间 并纳入排产计划 从接单 生产交货 提供了AI级别的控制,订单从txt直接导入易飞 加入了评审流程 大大提高了工作效率

完成了与易飞ERP\easyflow\考勤机\爬虫 等等消息集成,是一个独立运作的平台

3.该项目停止于2016年 由于系统更新换代为T100 不再维护

## 项目内容

### 项目文档

* 耀泰供应链管理系统.pdf
* 导入订单格式变更的说明.pdf
* 业务员TXT导入PI处理外箱方法解析.pdf
* 预测系统的规则和具体采购的流程.txt
* 易飞助手软件申请单.docx
* 产品检验管理系统操作手册.pdf
* 产品标识卡.pdf
* UME库存.PPT
* Kingfisher 报价和订单下载系统操作.doc
> 这些文档是面向使用者的 但是可以从中看到系统功能

### 主控项目

1. ERP助手.EXE
  * 该文件是 用户端安装盘,安装之后 产生[LU3.EXE]是桌面程序入口 启动的时候会调用[ERP.EXE]
  * [ERP.EXE]是每次启动 都会进行版本检测 有新版本 就从 数据库中 下载二进制文件[ERP.EXE]~该文件是我版本升级时候 升迁到服务器上的
  * 打包工具采用[Setup Factory 9] 基本没有用途 因为安装完毕后 后台自动升级
  * 启动后 同时启动[remotion.exe]
  * 系统运行前需要配置odbc 通过[config.exe]文件完成
  * [Dalert.exe]这个文件 是个客户端桌面提醒 被[ERP.EXE]启动时调用,比如BPM待审批的地方 PI待评审 会从用户右下角的图标处弹出来
  * 该系统 数据库有两套 一套是自己的主数据库trade 另外一套是第三方的易飞 易飞的表利用了自定义字段 完成一些特殊功能的处理,数据库采用的是MSSQLSERVER
> 注意：请参阅文档 所有模块都是对易飞ERP的完善 有很强的实用性 得到众多用户的认可 事半功倍的效益

2. cubemaster.exe
  * 这是一个集装箱的装箱文件 供[ERP助手.EXE]调用:用户在和客户沟通购买数量的时候 可以预先选择判断 货柜种类 购买多少货能装满一箱 货物怎么摆放
  * 算法上 确定货柜后 货品逐一 长宽高 给出最优摆放方案 供用户选择 并提供了各个货品 摆放位置的三维图形
> 注意：该算法的 WEB版不久我们也将推出来 正在制作中 提供网页版 和微信小程序 钉钉小程序版本

3. remotion.exe
  * 这个是前端底部显示 ShowBalloonTip:Easyflow工作流 没有审批的单据~通过腾讯通 自动提醒 给该审批的人~可以提高 OA表单 审批效率
  * 每天 有色金属交易网https://hq.smm.cn的金属价格提取,写入数据库 用于月底供应商 外购加工的产品价格的结算标准~因为如果获取月底平均价格 需要购买2W元年费 因此每天采集 月底汇总 用于财务与供应商价格结算~2017.5.1网站格式变更 因为从4.1日开始 SMM变更了网站格式 因此重新截取数据
  * 每天上午 从HR系统中取出员工生日 RTX 发送生日提醒:愿你天天快乐 年年好运 一生幸福
  * 每晚 定时生成财务日报表 供高管及CEO 通过手机APP[待开源] 查询ERP的企业 每天运营情况
  * 每晚 定时整理 订单 需要的物料 缺料的材料 会RTX通知采购员和生产计划员~发放工单的提醒 确保采购生产 正常进行~算法 是自创的 很有效
  * 每晚 逾期应收与预收等计算\PI评审\采购单 工单 订单的超期预警 RTX通知
  * 爬取 中国法院裁决文书http://wenshu.court.gov.cn,定时爬取~我们后来又写了个PYTHON版本的 用于破解该网站的加密....爬取浙江文书网http://wenshu.court.gov.cn/List/ListConten
  * 爬取 天气网http://ggfw.yy.gov.cn/bmfw/yyweather.asp,重要的气温台风变化 还有地质灾害RTX通知
  * 爬取 西刺免费代理 http://www.xicidaili.com/nn/~供爬虫使用 但是西刺的IP质量比较低 不建议使用
> 注意：RTX通知和计算量比较大的工作 都放在这个模块进行~爬虫分散给各个电脑终端上 获取数据 是为了提高效率。

4. oa.exe
  * 该文件需要部署 在RTX服务器上 才有效~因为需要 调用RTX 服务器接口
  * Easyflow工作流没有审批的单据 通过腾讯通自动提醒给该审批的人 可以提高OA表单审批效率
  * [OAVICE.exe]源码在IMWatch目录下~这个代码用于抓去后台 RTX聊天记录的拦截 写到数据库里面 因为RTX默认是不记录聊天内容的~这个工具 是隐含任务
> 注意：RTX通知和计算量比较大的工作 都放在这个模块进行~爬虫分散给各个电脑终端上 获取数据 是为了提高效率。

## 项目代码

* [GitHub](https://github.com/luhongbin/YiFeiERP)

## 技术栈

> 1. VFP9
> 2. VB

![](doc/pics/readme/technology-stack.png)

## 功能

### 服务记录
* 一个软件 企业各个方面信息集成了 C语言有一点 VB有一点 就是有些底层任务 VFP无法完成 只能用别的语言做 才能实现 比如拦截RTX的聊天记录 VFP做不到 二维码生成什么的 PDF转换 等类似的吧 都要一些第三方支持
* VFP9做的 微软已经淘汰了这个语言 这个语言我写了1988年DBASEII开始...到2018 三十年的积累大量子程序 玩的滚瓜烂熟  就被微软给废了...我也没按微软建议的该C# 直接跟GOOGLE跑了 现在都是互联网了 IOS ANDROID 小程序 WEB....搞这些了 慢慢我都开源吧
* 我们电脑实在跑不起来你这个软件:你把后台数据库建立起来 用SQL脚本...然后CONFIG.EXE配置ODBC的连接 你把后台数据库建立起来 用SQL脚本...然后CONFIG.EXE配置ODBC的连接...里面的管理思想 是值得借鉴的 SAP等企业都没我们这个APS做得好...订单下单之前 先分析企业最短完成时间...然后才能下单
* 这个项目 上去,企业效益立竿见影的 一下子就出来了...主要生产采购销售都被控制了...销售受产能制约(ERP理论无限产能)...生产被计算好..料件只能跟着订单跑 否则无法下单采购单 特殊情况 只能上级审批 基本都是系统自动生成的 ... 业务员 采购员 只是审核作用...订单也是导入的 不再是录入 效率很高...录入后 后续审批 按单别 才能下单 ... 很有序 把这个弄明白了 在那个企业都有饭吃了 方方面面都有 过些日子 我整理好 把android 和IOS的代码也开源出来一些
* Visual FoxPro在win10安装失败了:我发给你 WINDOWS各个版本都能跑...这个代码从DOS起步的 看到这个了吗?就是导入PI,PI审批之后会生成多个COPTC的文件 按不同单别...效率是很高的
* 能把这个软件上线 企业所有管理问题都解决了 以前公司外销部警察加班到十二点 做订单...上线之后 基本都能正常上下班了 无所事事
* 这里还有个 包装箱集中采购的算法 就是包装纸箱有个制版费 起印费...买多少个最划算的算法 集中采购的...一年轻轻松松 省出来费用几十万
* 以前我把算法放在后端 结果服务器都卡死了 晚上计算会延时到第二天出结果 我改用都放在前端 导入一个PI大约3分钟之内就能完成 订单就出来了... 我们这里数据库100G样子...操作员300来个使用这个系统
* 现在已经跑IOS ANDROID WEB跨平台 这个我没有完整的企业管理作品 都是局部功能...所以我这个意义本身不大...以前我们国外的工厂 都是VPN工作的....订单是国外分公司 EXCEL下单 通过我这个平台导入易飞....其实现在T100也是VPN方式工作 如果把这个系统用SPRINGBOOT 或者DIANGO完成 也不复杂 把现在这个C/S的移植过去 但是我没时间做这个了
* 先把成绩做出来 这个软件跑起来 管理效益经济效益 立竿见影 ... 一般工资先会给你翻倍...这套系统 研发到完全平稳 耗费几年时间 中间各种状况的处理 开源之后 你们就不用费心思搞了 这里基本都考虑到了
* 这代码能发下群共享里吗，我下不了:这个问题 你自己想法子解决 GITHUB必须有的 里面大量优质开源 可以利用 没有这个嫖什么?大厂都在嫖 你不嫖?
* 你去考察吧 对比我现在的功能 SAP 鼎捷 用友金蝶 他们都是你中有我 我中有你 互相抄袭...最初 我也不想费劲 抛给第三方开发 但是总达不到我们要求 我才自己动手的...都没有我们现在的软件爽 研发这个很费时间的  自己任意在框架下修改 补充适合自己的应用
* VFP做个东西很快...一个单子几分钟 报表一条命令 直接GRID的属性导出XML文件格式,用EXCEL打开就行 可以排序 这些都不用费事 系统自动完成的 一行命令 到处到EXCEL 带表头 带排序....这个功能 目前JAVA 和 PYTHON都没有 EXCEL处理的都比较啰嗦
* 详见源码和文档 不再一一说明

## 快速启动

1. 配置最小开发环境：
> 易飞使用环境
    
2. 数据库导入/dats/script.sql文件
> 这个是易飞助手的数据库文件 我们在易飞本身增加的字段不在这个数据库中 需要读者自行根据源码 在易飞数据表中建立自己的字段

3. 易飞助手的后端服务
    ```bash
    RTX服务器上 运行OAVICE.EXE
    RTX服务器上 运行OA.EXE
    ```
    
4. 启动前端

    ```bash
    CONFIG.EXE 文件配置好ODBC 然后setup factorys重新打包[ERP助手.EXE]
    ERP助手.EXE 客户端采用这个文件安装 即可允许
    ```
        
## 开发计划

目前本系统 已经不再维护

## 警告

> 1. 本项目仅用于学习练习
> 2. 本项目还不完善，仍处在开发中，不承担任何使用后果
> 3. 本项目代码开源[MIT](./LICENSE)，项目文档采用 [署名-禁止演绎 4.0 国际协议许可](https://creativecommons.org/licenses/by-nd/4.0/deed.zh)

## 问题

![](doc/pics/readme/bidding群二维码.png)

 * 开发者有问题或者好的建议可以用Issues反馈交流，请给出详细信息
 * 在开发交流群中应讨论开发、业务和合作问题
 * 如果真的需要QQ群657774700里提问，请在提问前先完成以下过程：
    * 请阅读[提问的智慧](https://github.com/ryanhanwu/How-To-Ask-Questions-The-Smart-Way/blob/master/README-zh_CN.md)；
    * 请百度或谷歌相关技术；
    * 请查看相关技术的官方文档，例如微信小程序的官方文档；
    * 请提问前尽可能做一些DEBUG或者思考分析，然后提问时给出详细的错误相关信息以及个人对问题的理解。

## License

[MIT](https://github.com/luhongbin/YiFeiERP/blob/master/LICENSE)
Copyright (c) 2021-present luhongbin
