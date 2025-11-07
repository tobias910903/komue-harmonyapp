/**
 * @AUTH lihuyong
 * @DATE 2025/11/4 15:23
 * @DESC 路由跳转工具类
 */
import { AppUtil } from '@pura/harmony-utils';
import { BusinessError } from '@ohos.base';
import { Router , UIContext } from '@kit.ArkUI';

// 声明接口
interface RouteParams {
  id?: string;
  num?: string;
  name?: string;
}

// 跳转到指定页面
export function goRoutePage(url: string, params: RouteParams | null = null): void {

  AppUtil.getUIContext().getRouter().pushUrl({
    url,
    params
  }).then(() => {
      console.info('succeeded');
  }).catch((error: BusinessError) => {
      console.error(`pushUrl failed, code is ${error.code}, message is ${error.message}`);
    })
}

// 获取路由参数
export function getRouteParams(): object {
  let uiContext: UIContext = AppUtil.getUIContext();
  let router: Router = uiContext.getRouter();
  return router.getParams();
}