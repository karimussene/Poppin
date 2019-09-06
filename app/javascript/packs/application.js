import "bootstrap";
import {selectFavoriteCuisine, selectedTick} from '../components/select_favorite_cuisine';

const cuisinesIndex = document.querySelector(".cuisines.index");
if(cuisinesIndex) {
  selectFavoriteCuisine();
  selectedTick();
}
