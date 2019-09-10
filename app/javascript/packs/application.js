import "bootstrap";
import {selectFavoriteCuisine, selectedTick} from '../components/select_favorite_cuisine';
import 'mapbox-gl/dist/mapbox-gl.css'; // <-- you need to uncomment the stylesheet_pack_tag in the layout!
import { initMapbox } from '../components/init_mapbox';


require("chartkick");
require("chart.js");

initMapbox();

const cuisinesIndex = document.querySelector(".cuisines.index");
if(cuisinesIndex) {
  selectFavoriteCuisine();
  selectedTick();
}

