export interface questionDetail{
  stem: string,
  id: string,
  content: string,
  answer: string,
  difficulty: number,
  stage: [
    string
  ],
  collectFlag: number,
  likeFlag: number,
  likeCount:number,
  creatorName: string,
  creatorAvatar: string,
  views: number,
  createdAt: string,
  relatedQuestions:relatedQuestions
}

export interface passId{
  id:string
}

export interface relatedQuestions{
  id:string
  questionNo:string
  stem:string
  createdAt:string
}

