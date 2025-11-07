import { window } from '@kit.ArkUI';
import { PreferencesUtil, ToastUtil, WindowUtil, DisplayUtil,NotificationBasicOptions,NotificationMultiLineOptions, NotificationUtil } from '@pura/harmony-utils';
import { goRoutePage } from '../utils/Router'
import { BusinessError } from '@kit.BasicServicesKit';
import { EventBus } from '@nutpi/eventbus';
import { DialogHelper } from '@pura/harmony-dialog';
import { SpinKit, SpinType } from '@pura/spinkit';
import { McPieChart, Options } from '@mcui/mccharts'


@Entry
@Component
export default struct TestIndex {
  scroller: Scroller = new Scroller();
  @State message: string = '功能DEMO';
  @State subWindow?: window.Window = undefined; //子窗口


  // 图表数据
  @State defOption: Options = new Options({
    title: {
      show: true,
      text: '测试饼图',
      left: 40,
      top: 20
    },
    series:[
      {
        data:[
          {value:435, name:'IOS'},
          {value:310, name:'安卓'},
          {value:234, name:'我心澎湃'},
          {value:135, name:'蓝河'},
          {value:1548, name:'鸿蒙'}
        ]
      }
    ]
  })

  aboutToAppear(): void {
    console.log("加载首页")
  }

  aboutToDisappear(): void {
    console.log("关闭首页")
  }

  build() {
    Column(){
      Scroll(this.scroller) {
        Column(){

          Text(this.message)
            .margin(20)

          Divider()
          Grid() {
            GridItem() {
              SpinKit({ spinType: SpinType.spinA })
            }
            GridItem() {
              SpinKit({ spinType: SpinType.spinB })
            }

            GridItem() {
              SpinKit({ spinType: SpinType.spinC })
            }

            GridItem() {
              SpinKit({ spinType: SpinType.spinX })
            }
            GridItem() {
              SpinKit({ spinType: SpinType.spinY })
            }

            GridItem() {
              SpinKit({ spinType: SpinType.spinZ })
            }
          }

          Divider()
          Button("弹出提示")
            .btnStyle()
            .onClick(() => {
              ToastUtil.showToast("弹出提示，默认时长为2s");
            })

          Divider()
          Button("路由跳转-带参数")
            .btnStyle()
            .onClick(() => {
              goRoutePage('pages/TestPage', { id: '123', num: '456', name: "test"});
            })

          Button("路由跳转-不带参数")
            .btnStyle()
            .onClick(() => {
              goRoutePage('pages/TestPage');
            })

          Divider()
          Button("设置本地数据")
            .type(ButtonType.Normal)
            .btnStyle()
            .onClick(async () => {
              PreferencesUtil.put("id", 10000018);
              PreferencesUtil.putSync("name", "张三叁");
              ToastUtil.showToast("数据缓存成功");
              let id = await PreferencesUtil.get("id", "");
              let name = PreferencesUtil.getSync("name", "");
              ToastUtil.showToast(`获取缓存：\nid: ${id}\nname: ${name}`);
            })
          Button("获取本地数据")
            .type(ButtonType.Normal)
            .btnStyle()
            .onClick(async () => {
              let id1 = await PreferencesUtil.getNumber("id");
              let id2 = PreferencesUtil.getNumberSync('id');
              let name1 = await PreferencesUtil.getString("name");
              let name2 = PreferencesUtil.getStringSync('name');
              ToastUtil.showToast(`获取缓存：\nid1: ${id1}\nid2: ${id2}\nname1: ${name1}\nname2: ${name2}`);
            })
          Button("获取boolean类型的缓存值")
            .type(ButtonType.Normal)
            .btnStyle()
            .onClick(async () => {
              PreferencesUtil.put("bl_nut", true);
              PreferencesUtil.putSync("bl_nuv", false);
              let bl1 = await PreferencesUtil.getBoolean("bl_nut");
              let bl2 = PreferencesUtil.getBooleanSync('bl_nuv');
              ToastUtil.showToast(`缓存·bl1：${bl1}\n缓存·bl2：${bl2}`);
            })
          Button("缓存中是否包含对应的键")
            .type(ButtonType.Normal)
            .btnStyle()
            .onClick(async () => {
              let bl1 = await PreferencesUtil.has("id");
              let bl2 = PreferencesUtil.hasSync('name');
              ToastUtil.showToast( `has~bl1：${bl1}\nhas~bl2：${bl2}`);
            })
          Button("删除本地数据")
            .type(ButtonType.Normal)
            .btnStyle()
            .onClick(async () => {
              PreferencesUtil.delete("id");
              PreferencesUtil.deleteSync("name");
              ToastUtil.showToast('删除缓存成功')
            })
          Button("清空本地数据")
            .type(ButtonType.Normal)
            .btnStyle()
            .onClick(() => {
              PreferencesUtil.clear();
              PreferencesUtil.clearSync();
              ToastUtil.showToast('清空缓存成功');
            })



         /* Divider()
          Button("打开一个新的窗口")
            .type(ButtonType.Normal)
            .btnStyle()
            .onClick(async ()=>{
              WindowUtil.createSubWindow({
                name: "子窗口Page",
                path: "pages/TestPage",
                width: await DisplayUtil.getWidth(),
                height: await DisplayUtil.getCutoutHeight(),
                // x: 80,
                // y: 80
              }).then((window) => {
                this.subWindow = window;
                this.subWindow.showWindow(); //显示窗口
              }).catch((err: BusinessError) => {
                ToastUtil.showToast(`异常信息：${err.message}`);
              });

            })*/

          Divider()
          Button("查询通知是否授权")
            .btnStyle()
            .onClick(async () => {
              let isEnabled = await NotificationUtil.isNotificationEnabled();
              ToastUtil.showToast(`查询通知是否授权: ${isEnabled}`);
            })
          Button("让用户选择是否允许发送通知")
            .btnStyle()
            .onClick(() => {
              NotificationUtil.requestEnableNotification().then(() => {
                ToastUtil.showToast(`让用户选择是否允许发送通知，成功！`);
              }).catch((err: BusinessError) => {
                ToastUtil.showToast(`让用户选择是否允许发送通知，失败，${err.message}`);
              });
            })
          Button("拉起应用的通知设置界面")
            .btnStyle()
            .onClick(() => {
              NotificationUtil.openNotificationSettings().then(() => {
                ToastUtil.showToast(`拉起应用的通知设置界面，成功！`);
              }).catch((err: BusinessError) => {
                ToastUtil.showToast(`拉起应用的通知设置界面，失败，${err.message}`);
              });
            })

          Button("授权通知服务")
            .btnStyle()
            .onClick(() => {
              NotificationUtil.authorizeNotification((grant) => {
                ToastUtil.showToast(`授权通知服务: ${grant ? '成功' : '失败'}`);
                if (!grant) {
                  NotificationUtil.openNotificationSettings(); //跳转通知设置页面
                }
              });
            })

          Button("手动发送一个通知")
            .btnStyle()
            .onClick(async () => {
              let wantAgent = await NotificationUtil.getDefaultWantAgent();
              let id = NotificationUtil.generateNotificationId(); //通知id
              let basicOptions: NotificationBasicOptions = {
                id: id,
                title: "鸿蒙工具包",
                text: "HarmonyOS工具包，封装了常用工具类，提供一系列简单易用的方法。帮助开发者快速构建鸿蒙应用",
                wantAgent: wantAgent
              }
              NotificationUtil.publishBasic(basicOptions).then((id) => {
                ToastUtil.showToast(`通知发送成功，id为：${id}`);
                // this.notificationIds.push(id);
              }).catch((err: BusinessError) => {
                ToastUtil.showToast(`通知发送失败，${err.message}`);
              });
            })
          Button("取消所有通知")
            .btnStyle()
            .onClick(() => {
              NotificationUtil.cancelAll();
              ToastUtil.showToast(`取消所有通知，成功！`);
            })
          Button("当前通知数量")
            .btnStyle()
            .onClick(async () => {
              let count = await NotificationUtil.getActiveNotificationCount();
              ToastUtil.showToast(`当前通知数量为：${count}`);
            })

          Divider()
          Button("on()")
            .btnStyle()
            .onClick(() => {
              //注册事件监听
              EventBus.on('id', (id: string) => {
                DialogHelper.showAlertDialog({
                  autoCancel: false,
                  backCancel: false,
                  content: `ID: ${id}`,
                  primaryButton: '已收到',
                  onAction: (action, id) => {
                    DialogHelper.closeDialog(id);
                  }
                });
              });
              ToastUtil.showToast(`注册事件监听成功！`);
            })
          Button("once()")
            .btnStyle()
            .onClick(() => {
              //注册单次事件监听
              EventBus.once('id', (id: string) => {
                DialogHelper.showAlertDialog({
                  autoCancel: false,
                  backCancel: false,
                  content: `单次ID: ${id}`,
                  primaryButton: '已收到',
                  onAction: (action, id) => {
                    DialogHelper.closeDialog(id);
                  }
                });
              });
              ToastUtil.showToast(`注册单次事件监听成功！`);
            })
          Button("post()")
            .btnStyle()
            .onClick(() => {
              EventBus.post('id', '100001200');
              ToastUtil.showToast(`发布普通消息！`);
            })
          Button("postSticky()")
            .btnStyle()
            .onClick(() => {
              EventBus.postSticky('id', '100001201');
              ToastUtil.showToast(`发布粘性消息！`);
            })
          Button("getSticky()")
            .btnStyle()
            .onClick(() => {
              let sticky = EventBus.getSticky('id');
              ToastUtil.showToast(`粘性事件数据：${sticky}`);
            })
          Button("removeSticky()")
            .btnStyle()
            .onClick(() => {
              EventBus.removeSticky('id');
              ToastUtil.showToast(`移除粘性事件成功！`);
            })
          Button("postApp()")
            .btnStyle()
            .onClick(() => {
              EventBus.postApp('id', '100001202');
              ToastUtil.showToast(`发布跨App消息！`);
            })
          Button("off()")
            .btnStyle()
            .onClick(() => {
              //注销事件监听
              EventBus.off('id');
              ToastUtil.showToast(`注销事件监听！`);
            })
          Button("offAll()")
            .btnStyle()
            .onClick(() => {
              //注销所有事件监听
              EventBus.offAll();
              ToastUtil.showToast(`注销所有事件监听！`);
            })

          Divider()
          Row() {
            McPieChart({
              options: this.defOption
            })
          }
          .height('300')

        }
        .width('100%')
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#ffcccc')
    .justifyContent(FlexAlign.Center)
  }
}

@Styles
function btnStyle() {
  .borderRadius(10)
  .margin({ top: 10, bottom: 10 })
  .padding({ top: 10, bottom: 10, left: 10, right: 10 })
}
