(function($){
 $(document).ready(function(){
   $('ul.sf-menu').superfish();

   // Users are _extremely_ unlikely to click on facets if all the facet categories are collapsed.
   if ($('.twiddle-open').length == 0){
     $($('.twiddle')[0]).addClass('twiddle-open').siblings('ul').show();
   }

   // There is no way to define an arbitrary sorting of facet values returned by Blacklight.
   // The Date range values are therefore sorted with JavaScript (in a very data-bound way).
   function sort_date_facets(){
     var list = $('.blacklight-date_range_facet ul');
     var all_list_elements = $('.blacklight-date_range_facet li').get();
     var non_numeric_list_elements = [];
     var numeric_list_elements = _.reject(all_list_elements, function(el){
       if (_.isNaN( $(el).text().replace(/^\s+/,'').split('-')[0] * 1 )){
         non_numeric_list_elements.push(el);
         return true;
       } else {
         return false;
       }
     });

     numeric_list_elements = _.sortBy(numeric_list_elements, function(el){return $(el).text().replace(/^\s+/,'').split('-')[0] * 1;});

     $.each(numeric_list_elements, function(index, li){
       list.append(li);
     });

     $.each(non_numeric_list_elements, function(index, li){
       if ( $(li).text().replace(/^\s+/,'').split('-')[0] == 'pre'){
         list.prepend(li);
       } else {
         list.append(li);
       }
     });
   }
   sort_date_facets();
 });
})(jQuery);
