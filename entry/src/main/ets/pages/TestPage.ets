import { window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { PreferencesUtil, ToastUtil, CrashUtil, DialogUtil, WindowUtil } from '@pura/harmony-utils';
import { getRouteParams } from '../utils/Router'
import { EventBus } from '@nutpi/eventbus';
import { DialogHelper } from '@pura/harmony-dialog';
import { HelloComponent } from "../components/HelloComponent"
import { IBestRollingText } from "@ibestservices/ibest-ui";
import { userApi } from '../api/user';

// 声明接口
interface RouteParams {
  id?: string;
  num?: string;
  name?: string;
}

interface User {
  id?: string,
  name?: string
}

@Entry
@Component
struct TestPage {
  scroller: Scroller = new Scroller();
  @State message: string = '组件 DEMO 测试：';
  @State subWindow?: window.Window = undefined; //子窗口
  @State userInfo: User|null = null;

  async getUserInfo() {
    try {
      const response = await userApi.getTestList({ per_page: 6, page: 1 });
      console.log(JSON.stringify(response))
      // const response = await userApi.getById(1);
      // this.userInfo = response.data;
    } catch (error) {
      console.error('加载用户列表失败:', error);
    } finally {

    }
  }

  submit: () => void = () => {
    console.log("触发点击事件")
  }

  aboutToAppear(): void {
    // WindowUtil.setWindowLayoutFullScreen(true); // 沉浸式导航

    //注销事件监听
    EventBus.off('id');
    ToastUtil.showToast(`注销事件监听！`);
  }

  aboutToDisappear(): void {
    // WindowUtil.setWindowLayoutFullScreen(false); // 沉浸式导航
  }

  build() {
    RelativeContainer() {
      Column() {
        Scroll(this.scroller) {

          Column(){
            Text(this.message);

            HelloComponent({
              message: '你好，世界!1',
              clickCallback: this.submit
            });

            IBestRollingText({
              startNum: 12345,
              targetNum: 54321,
              numWidth: 40,
              numHeight: 54,
              textBgColor: '#1989fa',
              fontColor: '#fff',
              fontSize: 24,
              gap: 6,
              radius: 4
            })


            Button('返回')
              .btnStyle()
              // 返回按钮绑定onClick事件，单击按钮时返回到第一页
              .onClick(() => {
                console.info(`Succeeded in clicking the 'Back' button.`)
                // 获取UIContext
                let uiContext: UIContext = this.getUIContext();
                let router = uiContext.getRouter();
                try {
                  // 返回第一页
                  router.back()
                  console.info('Succeeded in returning to the first page.')
                } catch (err) {
                  let code = (err as BusinessError).code;
                  let message = (err as BusinessError).message;
                  console.error(`Failed to return to the first page. Code is ${code}, message is ${message}`)
                }
              })

            Divider()
            Button("获取本地数据")
              .btnStyle()
              .onClick(async () => {
                let id1 = await PreferencesUtil.getNumber("id");
                let id2 = PreferencesUtil.getNumberSync('id');
                let name1 = await PreferencesUtil.getString("name");
                let name2 = PreferencesUtil.getStringSync('name');
                ToastUtil.showToast(`获取缓存：\nid1: ${id1}\nid2: ${id2}\nname1: ${name1}\nname2: ${name2}`);
              })

            Divider()
            Button('获取路由参数')
              .btnStyle()
              .onClick(() => {
                const str: RouteParams = getRouteParams();

                if(str){
                  // ToastUtil.showToast(str?.name);
                  // ToastUtil.showToast(str?.id);
                  ToastUtil.showToast(JSON.stringify(str));
                }else{
                  ToastUtil.showToast("当前路由没有参数");
                }
              })

            Divider()
            Button("制造一个异常")
              .btnStyle()
              .onClick(() => {
                throw new Error('未知异常！111');
              })
            Button("制造第二个异常")
              .btnStyle()
              .onClick(() => {
                throw new Error('未知异常！222');
              })
            Button("注销错误观测器")
              .btnStyle()
              .onClick(() => {
                CrashUtil.onDestroy(); //注销错误观测器
                ToastUtil.showToast("注销误观测器成功！");
              })
            Button("获取异常日志JSON")
              .btnStyle()
              .onClick(async () => {
                if (CrashUtil.access()) {
                  let jsonStr = await CrashUtil.getExceptionJson(); //读取JSON
                  // ToastUtil.showToast(jsonStr);

                  DialogUtil.showConfirmDialog({
                    title: "温馨提示",
                    message: jsonStr,
                    confirm: "确定",
                    onAction: () => {
                      ToastUtil.showToast("点击了“确定”按钮")
                    }
                  })

                } else {
                  ToastUtil.showToast("暂无日志文件");
                }
              })

            Divider()
            Button("请求HTTP接口")
              .btnStyle()
              .onClick(() => {
                this.getUserInfo()
              })


/*
            Divider()
            Button("销毁子窗口")
              .btnStyle()
              .onClick(() => {
                WindowUtil.destroyWindow("子窗口Page").then((result) => {
                  if (result) {
                    this.subWindow = undefined;
                  }
                  ToastUtil.showToast(`关闭：${result}`);
                }).catch((err: BusinessError) => {
                  ToastUtil.showToast(`异常信息：${err.message}`);
                });
              })*/
          }
        }.width('100%')
      }
    }

    .height('100%')
    .width('100%')
  }
}

@Styles
function btnStyle() {
  .borderRadius(10)
  .margin({ top: 10, bottom: 10 })
  .padding({ top: 10, bottom: 10, left: 10, right: 10 })
}


