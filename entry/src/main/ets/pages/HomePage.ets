import { HdSearch } from '../common/components/HdSearch'
import { BasicConstant } from '../common/constants/BasicContant'
import { Home } from '../views/home/Home'
import { HomeCategoryComp } from '../views/home/HomeCategoryComp'

@Entry
@Component
struct HomePage{
  build() {
    Scroll(){
      Column(){
        Home()
      }
    }
  }
}