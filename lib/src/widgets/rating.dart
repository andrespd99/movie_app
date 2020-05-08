import 'package:flutter/material.dart';

List<Widget> rating( double rating ) {

  rating = rating / 2;
  int ratingFloored = rating.truncate();
  List<Widget> starRating = new List();
  
  Map<String, Widget> starsDict = {
    'emptyStar'   : Icon( Icons.star_border, color: Colors.grey, ),
    'halfStar'    : Icon( Icons.star_half, color: Colors.amber, ),
    'star'        : Icon( Icons.star, color: Colors.amber, ),
  };
  /* Fill with stars for rating value floored */
  for(var i = 0; i < ratingFloored; i++)
    starRating.add(starsDict['star']);

  if( rating%1 < 0.4 )
    starRating.add(starsDict['emptyStar']);
  else if ( (0.4 < rating%1) && (rating%1 < 0.8) )
      starRating.add(starsDict['halfStar']);
  else 
    starRating.add(starsDict['star']);
  
  int leftToFill = 5 - starRating.length; 

  for(var i = 0; i < leftToFill; i++ ) {
    starRating.add(starsDict['emptyStar']);
  }

  return starRating;

}