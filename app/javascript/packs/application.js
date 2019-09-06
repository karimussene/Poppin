import "bootstrap";
import 'mapbox-gl/dist/mapbox-gl.css'; // <-- you need to uncomment the stylesheet_pack_tag in the layout!

import {selectFavoriteCuisine} from '../components/select_favorite_cuisine';
import { initMapbox } from '../components/init_mapbox';

selectFavoriteCuisine();
initMapbox();
