!function(){Gmaps4Rails.Google={},Gmaps4Rails.Google.Shared={createPoint:function(e,t){return new google.maps.Point(e,t)},createSize:function(e,t){return new google.maps.Size(e,t)},createLatLng:function(e,t){return new google.maps.LatLng(e,t)},createLatLngBounds:function(){return new google.maps.LatLngBounds},clear:function(){return this.serviceObject.setMap(null)},show:function(){return this.serviceObject.setVisible(!0)},hide:function(){return this.serviceObject.setVisible(!1)},isVisible:function(){return this.serviceObject.getVisible()}}}.call(this);