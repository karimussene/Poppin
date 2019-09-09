import mapboxgl from 'mapbox-gl';
import 'mapbox-gl/dist/mapbox-gl.css';

const fitMapToMarkers = (map, features) => {
  const bounds = new mapboxgl.LngLatBounds();
  features.forEach(({ geometry }) => bounds.extend(geometry.coordinates));
  map.fitBounds(bounds, { padding: 70, maxZoom: 15 });
  // markers.forEach(marker => bounds.extend([ marker.lng, marker.lat ]));
  // map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 });
};

const initMapbox = () => {
  const mapElement = document.getElementById('map');

  if (mapElement) { // only build a map if there's a div#map to inject into
    mapboxgl.accessToken = mapElement.dataset.mapboxApiKey;
    const map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/mapbox/streets-v10'
      // style: 'mapbox://styles/pdunleav/cjofefl7u3j3e2sp0ylex3cyb'
    });

  map.on('load', function() {
      const restaurants = JSON.parse(mapElement.dataset.restaurants);
      map.addSource('restaurants', {
        type: 'geojson',
        data: restaurants,
        // cluster: true,
        // clusterMaxZoom: 14,
        // clusterRadius: 50
      });

      map.addLayer({
        id: 'restaurants-heat',
        type: 'heatmap',
        source: 'restaurants',
        maxZoom: 15,

        paint: {
          // increase weight as diameter breast height increases
          'heatmap-weight': {
            property: 'attendance',
            type: 'exponential',
            stops: [
              [1, 0],
              [1500, 1]
            ]
          },
          // increase intensity as zoom level increases
          'heatmap-intensity': {
            stops: [
              [11, 1],
              [15, 3]
            ]
          },
          // assign color values be applied to points depending on their density
          'heatmap-color': [
            'interpolate',
            ['linear'],
            ['heatmap-density'],
            0, 'rgba(236,222,239,0)',
            0.2, 'rgb(254,217,142)',
            0.4, 'rgb(254,153,41)',
            0.6, 'rgb(217,95,14)',
            0.8, 'rgb(153,52,4)'
          ],
          // increase radius as zoom increases
          'heatmap-radius': {
            stops: [
              [11, 15],
              [15, 20]
            ]
          },
          // decrease opacity to transition into the circle layer
          'heatmap-opacity': {
            default: 1,
            stops: [
              [14, 1],
              [15, 0]
            ]
          },
        }
      }, 'waterway-label');

      map.addLayer({
        id: 'restaurants-point',
        type: 'circle',
        source: 'restaurants',
        minzoom: 14,
        paint: {
          // increase the radius of the circle as the zoom level and dbh value increases
          'circle-radius': {
            property: 'attendance',
            type: 'exponential',
            stops: [
              [{ zoom: 15, value: 1 }, 5],
              [{ zoom: 15, value: 1500 }, 10],
              [{ zoom: 22, value: 1 }, 20],
              [{ zoom: 22, value: 1500 }, 50],
            ]
          },
          'circle-color': {
            property: 'attendance',
            type: 'exponential',
            stops: [
              [0, 'rgb(236,222,239)'],
              [100, 'rgb(236,222,239)'],
              [200, 'rgb(208,209,230)'],
              [400, 'rgb(166,189,219)'],
              [600, 'rgb(103,169,207)'],
              [800, 'rgb(28,144,153)'],
              [1000, 'rgb(0,109,44)']
            ]
          },
          'circle-stroke-color': 'white',
          'circle-stroke-width': 1,
          'circle-opacity': {
            stops: [
              [14, 0],
              [15, 1]
            ]
          }
        }
      }, 'waterway-label');

      // map.addLayer({
      //   id: 'clusters',
      //   type: 'circle',
      //   source: 'restaurants',
      //   filter: ['has', 'point_count'],
      //   paint: {
      //     'circle-color': [
      //       'step',
      //       ['get', 'point_count'],
      //       '#51bbd6',
      //       100,
      //       '#f1f075',
      //       750,
      //       '#f28cb1'
      //     ],
      //     'circle-radius': [
      //       'step',
      //       ['get', 'point_count'],
      //       20,
      //       100,
      //       30,
      //       750,
      //       40
      //     ]
      //   }
      // });

      // map.addLayer({
      //   id: 'cluster-count',
      //   type: 'symbol',
      //   source: 'restaurants',
      //   filter: ['has', 'point_count'],
      //   layout: {
      //     'text-field': '{point_count_abbreviated}',
      //     'text-font': ['DIN Offc Pro Medium', 'Arial Unicode MS Bold'],
      //     'text-size': 12
      //   }
      // });

      // map.addLayer({
      //   id: 'unclustered-point',
      //   type: 'circle',
      //   source: 'restaurants',
      //   filter: ['!', ['has', 'point_count']],
      //   paint: {
      //     'circle-color': '#11b4da',
      //     'circle-radius': 10,
      //     'circle-stroke-width': 1,
      //     'circle-stroke-color': '#fff'
      //   }
      // });

      // map.on('click', 'clusters', function (e) {
      //   const features = map.queryRenderedFeatures(e.point, { layers: ['clusters'] });
      //   const clusterId = features[0].properties.cluster_id;

      //   map.getSource('restaurants').getClusterExpansionZoom(clusterId, function (err, zoom) {
      //     if (err) return;

      //     map.easeTo({
      //       center: features[0].geometry.coordinates,
      //       zoom: zoom
      //     });
      //   });
      // });

      // map.on('mouseenter', 'clusters', function (e) {
      //   map.getCanvas().style.cursor = 'pointer';
      // });

      // map.on('mouseleave', 'clusters', function () {
      //   map.getCanvas().style.cursor = '';
      // });

      // map.on('click', 'unclustered-point', function (e) {
      //   const features = map.queryRenderedFeatures(e.point, { layers: ['unclustered-point'] });
      //   const infoWindow = features[0].properties.info_window;
      //   const coordinates = features[0].geometry.coordinates;

      //   map.easeTo({
      //     center: features[0].geometry.coordinates
      //   });

      //   new mapboxgl.Popup()
      //     .setLngLat(coordinates)
      //     .setHTML(infoWindow)
      //     .addTo(map);
      // });

      // map.on('mouseenter', 'unclustered-point', function () {
      //   map.getCanvas().style.cursor = 'pointer';
      // });

      // map.on('mouseleave', 'unclustered-point', function () {
      //   map.getCanvas().style.cursor = '';
      // });

      fitMapToMarkers(map, restaurants.features);
    });
  }





  //   const markers = JSON.parse(mapElement.dataset.markers);
  //   markers.forEach((marker) => {
  //     const popup = new mapboxgl.Popup().setHTML(marker.infoWindow); // add this

  //     new mapboxgl.Marker()
  //       .setLngLat([ marker.lng, marker.lat ])
  //       .setPopup(popup) // add this
  //       .addTo(map);
  //   });

  //   fitMapToMarkers(map, markers);
  //   map.addControl(new MapboxGeocoder({ accessToken: mapboxgl.accessToken }));
  // }

};

export { initMapbox };
