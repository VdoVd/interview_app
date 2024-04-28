export interface homeSubListModel{
  total:number
  pageTotal:number
  rows:homeSubItemModel[]
}

export interface homeSubItemModel{
  id:string
  questionNo:string
  stem:string
  content:String
  stemAttachmentId:string
  subjectName:string
  questionType:number
  planSceneName:string
  difficulty:number
  createdAt:string
  views:number
  likeCount:number
  likeFlag:number
  creatorAvatar:string
  creatorName:string
  readFlag:number
}

export interface subListQuery{
  type?:string
  keyword?:string
  sort?:string
  pageSize?:string
  page?:string
  questionBankType:string
}