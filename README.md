# YiFeiERP

1.基于C/S架构的制造型企业的管理系统 首版开发起始于上个世纪80年代 当时DBASEII 之后FOXBASE用于企业管理的数据处理,使用环境是PC DOS

微软推出WINDOWS后 开发工具VFP推出~软件升级为WINDOWS版本 相关积累的子程序 一并升级 满足新系统需求

这个平台积累了 数十家企业 不同行业的经验 都是基于 这个框架 开发的 涉及 供产销人财物的 方方面面

2.YiFeiERP这个开源作品 也是基于上述框架 对鼎捷的易飞ERP进行外挂~~已经有多年 实际应用经验~主要是完善 补充易飞ERP(现在的T100)功能 实现对企业更有效的管控

比如自研的APS,把产能\人力资源\物料整体分析后 业务员下单前 进行判断 不满足条件 无法下单~~会提供最早交货时间 并纳入排产计划 从接单 生产交货 提供了AI级别的控制,订单从txt直接导入易飞 加入了评审流程 大大提高了工作效率

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
  * 每晚 定时整理 订单 需要的物料 缺料的材料 会RTX通知采购员和生产计划员~发放工单的提醒 确保采购生产 正常进行~~算法 是自创的 很有效
  * 每晚 逾期应收与预收等计算\PI评审\采购单 工单 订单的超期预警 RTX通知
  * 爬取 中国法院裁决文书http://wenshu.court.gov.cn,定时爬取~我们后来又写了个PYTHON版本的 用于破解该网站的加密....爬取浙江文书网http://wenshu.court.gov.cn/List/ListConten
  * 爬取 天气网http://ggfw.yy.gov.cn/bmfw/yyweather.asp,重要的气温台风变化 还有地质灾害RTX通知
  * 爬取 西刺免费代理 http://www.xicidaili.com/nn/~供爬虫使用 但是西刺的IP质量比较低 不建议使用
> 注意：RTX通知和计算量比较大的工作 都放在这个模块进行~爬虫分散给各个电脑终端上 获取数据 是为了提高效率。

4. oa.exe
  * 该文件需要部署 在RTX服务器上 才有效~因为需要 调用RTX 服务器接口
  * Easyflow工作流没有审批的单据 通过腾讯通自动提醒给该审批的人 可以提高OA表单审批效率
  * [OAVICE.exe]源码在IMWatch目录下~这个代码用于抓去后台 RTX聊天记录的拦截 写到数据库里面 因为RTX默认是不记录聊天内容的~这个工具 是隐含任务
> 注意：RTX通知和计算量比较大的工作 都放在这个模块进行~~爬虫分散给各个电脑终端上 获取数据 是为了提高效率。

## 项目代码

* [GitHub](https://github.com/luhongbin/YiFeiERP)

## 技术栈

> 1. VFP9
> 2. VB

![](doc/pics/readme/technology-stack.png)

## 功能

### 小商城功能

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
