// News Carousel Design

/*
  Widget _buildNewsCarousel(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(16.0)),
      // Main News Header and News Carousel
      child: GestureDetector(
          onHorizontalDragStart: (DragStartDetails start) => _reloadHeader(),
          child: Stack(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                child: FadeInImage.assetNetwork(
                  height: Constants.carouselHeight,
                  placeholder: Constants.placeholder,
                  image: banner[_currentIndex],
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 0.0,
                right: 0.0,
                left: 0.0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromARGB(0, 0, 0, 0),
                          Color.fromARGB(200, 0, 0, 0)
                        ]),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 30, 12, 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        //
                        // Main Header Title
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            bannerTitles[_currentIndex],
                            style: GoogleFonts.cairo(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  */
