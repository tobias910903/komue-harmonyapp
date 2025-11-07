/**
 * @AUTH lihuyong
 * @DATE 2025/11/6 16:13
 * @DESC 配置
 */

// 当前运行环境 dev开发 prod生产
const ENV: 'dev' | 'prod' = 'dev';

// 定义子对象的类型
interface Detail {
  ENV: string,
  BASEURL: string,
  TITLE: string,
}

// 定义父对象的类型
interface ParentObj {
  dev: Detail,
  prod: Detail,
}

// 配置
const config: ParentObj = {
  dev: {
    ENV,
    BASEURL: "https://www.lihuyong.com",
    TITLE: "测试环境标题",
  },
  prod: {
    ENV,
    BASEURL: "https://www.lihuyong.com",
    TITLE: "生产环境标题",
  }
}

// 定义函数：从父对象中获取子对象并返回
function getConfigObject(key: string): Detail|object {
  if(key === 'dev'){
    return config.dev
  }

  if(key === 'prod'){
    return config.prod
  }

  return {}
}

// 获取对应环境的配置
const GLOBAL_CONFIG: Detail|object = getConfigObject(ENV);

// 导出
export default GLOBAL_CONFIG