
var autocomplete;

function autocomplete() {

  var Address = document.getElementById('input_address');
  autocomplete = new google.maps.places.Autocomplete(Address, { types: [ 'geocode' ] });

  if (Address) {

    // Get each component of the address from the place details
    // and fill the corresponding field on the form.

    google.maps.event.addDomListener(Address, 'keydown', function(e) {
      if (e.key === "Enter") {
        e.preventDefault(); // Do not submit the form on Enter.
      }
    });
  }

  autocomplete.addListener('place_changed', fillInAddress);
}

function fillInAddress() {
  console.log('ttoto')
  // Get the place details from the autocomplete object.
  var place = autocomplete.getPlace();
  var componentForm = {
    locality: 'long_name',
  };

  for (var component in componentForm) {
    document.getElementById(component).value = '';
    document.getElementById(component).disabled = false;
  }

  // Get each component of the address from the place details
  // and fill the corresponding field on the form.
  for (var i = 0; i < place.address_components.length; i++) {
    var addressType = place.address_components[i].types[0];
    if (componentForm[addressType]) {
      var val = place.address_components[i][componentForm[addressType]];
      document.getElementById(addressType).value = val;
    }
  }
}




export { autocomplete };
