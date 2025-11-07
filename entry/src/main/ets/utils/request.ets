/**
 * @AUTH lihuyong
 * @DATE 2025/11/6 11:06
 * @DESC 网络请求
 */

import axios, { AxiosInstance, InternalAxiosRequestConfig, AxiosResponse, AxiosError } from '@ohos/axios';
import GLOBAL_CONFIG from "../config";
console.log(JSON.stringify(GLOBAL_CONFIG));


// 简单的token获取方法（仅保留基础逻辑，实际项目可根据存储方式修改）
// 注意：此处仅为请求拦截器添加token用，无其他token管理逻辑
async function getToken(): Promise<string | null> {
  // 实际项目中可从偏好设置、内存等位置获取token
  // 示例：从内存变量获取（仅作演示）
  // return globalThis.appToken || null;
  return "token_test_123456";
}

// 创建axios实例
const service: AxiosInstance = axios.create({
  baseURL: 'https://www.lihuyong.com', // 基础API地址
  timeout: 15000, // 超时时间
  headers: {
    'Content-Type': 'application/json;charset=utf-8'
  }
});

// 请求拦截器（仅保留添加token的逻辑）
service.interceptors.request.use(async (config: InternalAxiosRequestConfig) => {
  console.log(JSON.stringify(config));

    // 添加token到请求头
    const token = await getToken();
    if (token && config.headers) {
      config.headers.Authorization = `Bearer ${token}`;
      console.log('请求已添加token');
    }
    return config;
  },
  (error: AxiosError) => {
    console.error('请求拦截器错误:', error.message);
    return Promise.reject(error);
  }
);

// 响应拦截器（移除所有token相关处理，仅保留基础响应和错误处理）
service.interceptors.response.use((response: AxiosResponse) => {

    // const data = response?.data;
    console.log(JSON.stringify(response));

    // 根据后端实际返回格式调整（示例：假设code=200为成功）
    if (response.data.code === 200) {
      console.log('请求成功:', response.config.url);
      return response.data; // 只返回数据部分
    } else {
      console.log('操作失败:', response.data.message || '请求返回非成功状态');
      return Promise.reject(new Error(response.data.message || '请求错误'));
    }
  },
  (error: AxiosError) => {
    // 移除token过期（401）相关处理逻辑
    const errorMsg = getErrorMsg(error);
    console.log('请求错误:', errorMsg);
    return Promise.reject(error);
  }
);

// 错误信息处理（替换UI提示为console.log）
function getErrorMsg(error: AxiosError): string {
  if (error.response) {
    switch (error.response.status) {
      case 400: return '请求参数错误';
      case 403: return '没有权限访问';
      case 404: return '请求资源不存在';
      case 500: return '服务器内部错误';
      default: return `请求失败: ${error.response.status}`;
    }
  } else if (error.message.includes('timeout')) {
    return '请求超时，请稍后重试';
  } else {
    return '网络连接异常，请检查网络';
  }
}

export default service;