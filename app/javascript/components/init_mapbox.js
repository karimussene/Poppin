import mapboxgl from 'mapbox-gl';

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
      style: 'mapbox://styles/mapbox/dark-v10'
      // style: 'mapbox://styles/pdunleav/cjofefl7u3j3e2sp0ylex3cyb'
    });

  map.on('load', function() {
      const restaurants = JSON.parse(mapElement.dataset.restaurants);
      console.log(restaurants)
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
              [200, 0.33],
              [400, 0.66],
              [600, 1]
              // [800, 0.8],
              // [1000, 1]
            ]
          },
          // increase intensity as zoom level increases
          'heatmap-intensity': {
            stops: [
              [11, 3],
              [15, 6]
            ]
          },
          // assign color values be applied to points depending on their density
          'heatmap-color': [
            'interpolate',
            ['linear'],
            ['heatmap-density'],
             0, 'rgba(236,222,239,0)',
             0.25, 'rgb(255,237,181)',
             0.5, 'rgb(255,223,128)',
             0.75, 'rgb(255,236,92)',
             1, 'rgb(255,204,51)'
          ],
          // increase radius as zoom increases
          'heatmap-radius': {
            stops: [
              [11, 20],
              [15, 30]
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
              [{ zoom: 15, value: 200 }, 10],
              [{ zoom: 15, value: 400 }, 15],
              [{ zoom: 15, value: 600 }, 20],
              [{ zoom: 15, value: 800 }, 25],
              // [{ zoom: 22, value: 1 }, 20],
              // [{ zoom: 22, value: 200 }, 30],
              // [{ zoom: 22, value: 400 }, 40],
              // [{ zoom: 22, value: 600}, 50],
              // [{ zoom: 22, value: 800 }, 60]
            ]
          },
          'circle-color': {
            property: 'attendance',
            type: 'exponential',
            stops: [
               [0, 'rgba(236,222,239,0)'],
               [250, 'rgb(255,237,181)'],
               [500, 'rgb(255,223,128)'],
               [750, 'rgb(255,236,92)'],
               [1000, 'rgb(255,204,51)']
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
