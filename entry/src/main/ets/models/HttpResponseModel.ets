export interface HdResponse<T> {
  /**
   * 请求成功10000标志
   */
  code: number;
  /**
   * 返回数据
   */
  data: T;
  /**
   * 请求成功
   */
  message: string;
  /**
   * 请求成功标志
   */
  success: boolean;
}