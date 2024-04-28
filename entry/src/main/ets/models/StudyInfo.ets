export interface ListItemStudy {
  id: string
  name: string
  total: number
  done: number
  undone: number
}

export interface StudyDataList {
  type: string;
  list: ListItemStudy[];
}

export interface StudyData {
  totalTime: number;
  studyData: StudyDataList[];
}

export interface RootObject {
  success: boolean;
  code: number;
  message: string;
  data: StudyData;
}