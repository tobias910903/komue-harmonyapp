import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { AppUtil, CrashUtil, ToastUtil } from '@pura/harmony-utils';
import { DialogHelper } from '@pura/harmony-dialog';
import { ArkWebHelper } from '@pura/harmony-web';
import { IBestInit } from "@ibestservices/ibest-ui";

const DOMAIN = 0x0000;

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    try {
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);

      AppUtil.init(this.context);

      ArkWebHelper.init(this.context, true);

      CrashUtil.onHandled((exceptionInfo)=>{ // 异常捕获
        // ToastUtil.showToast("注册观测器，成功！");
        ToastUtil.showToast("程序发生异常：" + JSON.stringify(exceptionInfo, null, 2));
      });

      DialogHelper.setDefaultConfig((config) => {
        config.uiAbilityContext = this.context;
        config.autoCancel = false; //点击遮障层时，是否关闭弹窗，true表示关闭弹窗。
        config.backCancel = false; //点击返回键或手势返回时，是否关闭弹窗；实现onWillDismiss函数时，该参数不起作用。
        config.actionCancel = true; //点击操作按钮时，是否关闭弹窗。false表示不关闭弹窗。
        config.alignment = DialogAlignment.Center; //弹窗的对齐方式。
        config.offset = { dx: 0, dy: 0 }; //弹窗相对alignment所在位置的偏移量。默认值：{ dx: 0, dy: 0 }
        config.maskColor = 0x11000000; //自定义蒙层颜色。默认值 0x33000000
        config.backgroundColor = Color.White; //弹窗背板颜色。默认值：Color.White
        config.backgroundBlurStyle = BlurStyle.NONE; //弹窗背板模糊材质
        config.cornerRadius = 35; //设置背板的圆角半径。可分别设置4个圆角的半径。
        // config.maskRect={ x: 'auto', y: 'auto', width: 'auto', height: 'auto' };

        config.title = $r("app.string.dialog_tip"); //弹框标题
        config.primaryButton = $r("app.string.btn_cancel"); //弹框左侧按钮。
        config.secondaryButton = $r("app.string.btn_sure"); //弹框右侧按钮。
        config.imageRes = undefined; //TipsDialog用到，展示的图片。
        config.imageSize = { width: '64vp', height: '64vp' }; //TipsDialog用到，自定义图片尺寸。默认值：64*64vp

        config.loading_loadSize = 60; //加载动画或进度条的大小
        config.loading_loadColor = Color.White; //加载动画或进度条的颜色
        config.loading_content = ''; //加载动画的提示文字
        config.loading_fontSize = 16; //文字大小
        config.loading_fontColor = Color.White; //文字颜色
        config.loading_backgroundColor = '#CC094CD1'; //背景颜色，八位色值前两位为透明度
        config.loading_borderRadius = 10; //背景圆角

        config.toast_fontSize = 16; //文字大小
        config.toast_fontColor = Color.White; //文字颜色
        config.toast_backgroundColor = '#CC56D866'; //背景颜色，建议八位色值前两位为透明度
        config.toast_alignment = Alignment.Center; //土司居中显示
        config.toast_borderRadius = 8; //背景圆角
        config.toast_padding = { left: 16, right: 16, top: 12, bottom: 12 }; //Padding
        config.toast_imageSize = { width: 45, height: 45 }; //Tip图片尺寸。默认值：45*45vp
        config.toast_duration = 2000; //显示时长(1500ms-10000ms)
        config.toast_durationLong = 5000; //显示时长
      });


    } catch (err) {
      hilog.error(DOMAIN, 'testTag', 'Failed to set colorMode. Cause: %{public}s', JSON.stringify(err));
    }
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/TestIndex', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');

      // 注册UI组件
      IBestInit(windowStage, this.context);
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
  }

  //返回true表示UIAbility将会被移到后台不销毁，返回false表示UIAbility将正常销毁。
  onBackPressed(): boolean {
    return true;
  }
}