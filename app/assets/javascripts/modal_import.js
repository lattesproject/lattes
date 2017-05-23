$(document).ready(function() {
    $('#modal-import-cv').on('show.bs.modal', function (event) {
        var button = $(event.relatedTarget) // Button that triggered the modal
        var event = button.data('event') // Extract info from data-* attributes
        
        // Update the- modal's content. We'll use jQuery here, but you could use a data binding library or other methods instead.
        var modal = $(this)
        modal.find('#events_event_id').val(event)
    });

    $('#modal-import-cv').on('hidden.bs.modal', function (event) {
        $(this).find("input,textarea,select").val('').end();
    });

});