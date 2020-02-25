# 1.  练习目的
## 1.熟悉swift 语言
## 2.先自行用MVC架构实现录音app
## 3.比对与Objc.io 的实现细节,看看自己对MVC 的理解是否到位

# 2.需求介绍
## 1.App 由三个主要界面,Folder 文件目录界面,可以新建文件和编辑文件;Record界面 用来录音的;Player界面 用来播放录音.其中Floder 和 Record 界面是作为SplitViewController的子界面来使用的
## 2.App 需要对数据进行持久化,包括文件目录以及录音信息
## 3.在Folder界面,点击一个item的时候,要区分是 录音还是文件夹,两者进行的操作是不同的


# 3.架构要解决什么问题
## 1. 构建—谁负责构建model和view，以及将两者连接起来?
//MVC: Controller
## 2. 更新model—如何处理viewaction?
//MVC: 四步骤①view 发起viewaction 到 controller ②controller 调用model 层相关方法 ③ model 层完成更改发送通知 ④ controller 接收通知更新UI 这就是最标准的处理
## 3. 改变view—如何将model的数据应用到view上去?
//MVC: setModel
## 4. viewstate—如何处理导航和其他一些modelstate以外的状态?
//MVC: 在View 或者 ViewController 内部处理,不在需要将状态传递到外部
## 5. 测试—为了达到一定程度的测试覆盖，要采取怎样的测试策略?
当我们在谈论架构的时候,我们究竟在谈论什么?
是模块如何划分,如何通信? 还是一个模块内部诸如model,view这些该如何划分,相互之间该如何通信?
按照上面的描述明显是属于后一种

# 4.一些思考
## 1.对于model 层的思考
一直以来开发的项目并没有做好model层的处理,习惯于拿接口数据显示到界面上罢了.

有一点进步的是,对于部分数据能够有意识的在model中处理一下,在拿到ViewController中使用
对于过往项目中,如钱包HD钱包的数据/mt货币对列表数据,其实都是属于model的东西,在学习完这本书之后,能否有一些更好的处理方法

一个典型的例子,mt4的自选列表界面每次进入都要重新请求接口,去拿最新的数据.
因为在添加自选界面,或者K界面有做添加/删除自选的操作,但是每次都重新请求,则造成了流量了浪费.
如果你有一个自选的model层,每次自选数据变更,同步更新model 层即可. 然后model 发出通知,自选列表界面刷新数据即可.


## 2.ViewController 的处理
学习完结构对于钱包的转账界面 和 mt 的交易界面能否提出一种好的解决方案


# 5.MVC 中各个模块的职责,以及通信方式
## 1.各模块职责
### ViewController :创建View,展示View,接收ViewAction,观察Model,协调Model和View的工作
### View:
### Model:

## 2. ViewController 优化的方法
### 1.分离一些的业务逻辑到Model 层,比如排序,或者其他数据处理
### 2.分离一些专有业务逻辑到工具类,比如网络请求,地图相关的处理
### 3.管理了超过一个的主View.这种情况可以使用子控制器处理
### 4.利用 childViewController 进行代码重构,分离一些较为独立的功能
### 5.提取对象.将其中一个或多个角色的职责抽象到一个类里面,比如抽象vc中tableView 的dataSource 到一个单独的 DataSource 类
### 6.简化View 配置代码,即setModel 


## 3.通信方式

