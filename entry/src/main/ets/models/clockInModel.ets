
export interface clockIn{

  /**
   * 头像
   */
  avatar: string;
  /**
   * 背景图片地址
   */
  backgroudPicture: string;
  /**
   * 连续打卡的天数
   */
  clockinNumbers: number;
  /**
   * 打卡总天数
   */
  clockinTotal: number;
  /**
   * 小程序二维码
   */
  miniAppPicture: string;
  /**
   * 昵称
   */
  nickName: string;


}

export interface ClockIn {
  id: string;
  createdAt: string;
}

export interface ClockInData {
  flag: boolean;
  clockinNumbers: number;
  totalClockinNumber: number;
  clockins: ClockIn[];
}


