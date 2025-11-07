/**
 * @AUTH lihuyong
 * @DATE 2025/11/6 11:20
 * @DESC 用户
 */
import service from '../utils/request';

interface User {
  id: number;
  name: string;
  email: string;
  age: number;
}

interface UserListResponse {
  data: User[];
  total: number;
  page: number;
  size: number;
}

interface ParamsTest {
  per_page: number;
  page: number;
}

// 定义接口，约束 userApi 的结构和函数类型
interface UserApiType {
  getById: (id: number) => object;
  // getList: (page: number, size: number) => void;
  getTestList: (params: ParamsTest) => void;
}


export const userApi: UserApiType = {

  // 获取单个用户
  getById: (id) => service({
    url: `/wp-json/wp/v2/users/${id}`
  }),

  // 获取列表
  getTestList: (params) => service({
    url: `/wp-json/wp/v2/posts`,
    // method: 'get', // 默认get
    params
  }),
};