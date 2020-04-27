
class Cast {

  List<Actor> actors = new List();

  Cast();

  Cast.fromJsonList( List<dynamic> jsonList ) {

    if( jsonList == null ) return;

    jsonList.forEach( ( actor ) {
      final newActor = Actor.fromJsonMap(actor);
      actors.add( newActor );
    });    
  }
}

class Actor {
  int castId;
  String character;
  String creditId;
  int gender;
  int id;
  String name;
  int order;
  String profilePath;

  Actor({
    this.castId,
    this.character,
    this.creditId,
    this.gender,
    this.id,
    this.name,
    this.order,
    this.profilePath,
  });

  Actor.fromJsonMap( Map<String, dynamic> json ) {
    castId        = json['cast_id'];
    character     = json['character'];
    creditId      = json['credit_id'];
    gender        = json['gender'];
    id            = json['id'];
    name          = json['name'];
    order         = json['order'];
    profilePath   = json['profile_path'];
  }

  getActorPhoto() {
    
    if ( profilePath == null ) {
      return 'https://images.assetsdelivery.com/compings_v2/apoev/apoev1806/apoev180600175.jpg';
    } else {
      return 'https://image.tmdb.org/t/p/w500/$profilePath';
    }
    
  }

}


