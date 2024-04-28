export interface QuestionType {
  id: number
  name: string
  displayNewestFlag: 0 | 1
}

export class QuestionTypeModel implements QuestionType {
  id: number = 0
  name: string = ''
  displayNewestFlag: 0 | 1 = 0

  constructor(model: QuestionType) {
    this.id = model.id
    this.name = model.name
    this.displayNewestFlag = model.displayNewestFlag
  }
}