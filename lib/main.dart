import 'package:flutter/material.dart';
import 'package:flutter_app/WeatherBloc.dart';
import 'package:flutter_app/WeatherModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/WeatherRepo.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.grey[900],
          body: BlocProvider(
            create: (context) =>
                WeatherBloc(WeatherIsNotSearched(), WeatherRepo()),
            //builder: (context) => WeatherBloc(WeatherRepo()),
            child: ChooseModeScreen(),
          ),
        ));
  }
}

class ChooseModeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: <Widget>[
      Expanded(
        child: Container(
          width: double.infinity,
          height: 50,
          child: FlatButton(
            onPressed: () {
              navigateToStandardMode(context);
            },
            color: Colors.blue,
            child: Text(
              "Normalny widok",
              style: TextStyle(color: Colors.white70, fontSize: 36),
            ),
          ),
        ),
      ),
      Expanded(
        child: Container(
          width: double.infinity,
          height: 50,
          child: FlatButton(
            onPressed: () {
              navigateToGrandMode(context);
            },
            color: Colors.blue,
            child: Text(
              "Duży widok",
              style: TextStyle(color: Colors.white70, fontSize: 64),
            ),
          ),
        ),
      ),
    ]));
  }

  void navigateToStandardMode(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => BlocProvider.value(
              value: BlocProvider.of<WeatherBloc>(context),
              child: StandardSearchPage(),
            )));
  }

  void navigateToGrandMode(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => BlocProvider.value(
              value: BlocProvider.of<WeatherBloc>(context),
              child: GrandSearchPage(),
            )));
  }
}

class GrandSearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final weatherBloc = BlocProvider.of<WeatherBloc>(context);
    var cityController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.blue,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          BlocBuilder<WeatherBloc, WeatherState>(
            builder: (context, state) {
              if (state is WeatherIsNotSearched)
                return Container(
                  padding: EdgeInsets.only(
                    left: 32,
                    right: 32,
                  ),
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Text(
                          "Wpisz miasto",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 64,
                              fontWeight: FontWeight.w200,
                              color: Colors.white70),
                        ),
                      ),
                      SizedBox(
                        height: 52,
                      ),
                      TextFormField(
                        controller: cityController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.white70,
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                  color: Colors.white70,
                                  style: BorderStyle.solid)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                  color: Colors.blue,
                                  style: BorderStyle.solid)),
                          hintText: "Wpisz nazwę miasta!",
                          hintStyle: TextStyle(color: Colors.white70),
                        ),
                        style: TextStyle(color: Colors.white70, fontSize: 36),
                      ),
                      SizedBox(
                        height: 52,
                      ),
                      Container(
                        width: double.infinity,
                        height: 100,
                        child: FlatButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          onPressed: () {
                            weatherBloc.add(FetchWeather(cityController.text));
                          },
                          color: Colors.lightBlue,
                          child: Text(
                            "Szukaj",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 48),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              else if (state is WeatherIsLoading)
                return Center(child: CircularProgressIndicator());
              else if (state is WeatherIsLoaded)
                return ShowWeatherGrand(state.getWeather, cityController.text);
              else
                return Container(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Przepraszamy, nie znaleziono lokalizacji",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 48),
                        ),
                      ),
                      SizedBox(
                        height: 150,
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: 200,
                        child: FlatButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          onPressed: () {
                            BlocProvider.of<WeatherBloc>(context)
                                .add(ResetWeather());
                          },
                          color: Colors.lightBlue,
                          child: Text(
                            "Szukaj ponownie",
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: Colors.white70, fontSize: 48),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
            },
          )
        ],
      ),
    );
  }
}

class StandardSearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final weatherBloc = BlocProvider.of<WeatherBloc>(context);
    var cityController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.blue,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          BlocBuilder<WeatherBloc, WeatherState>(
            builder: (context, state) {
              if (state is WeatherIsNotSearched)
                return Container(
                  padding: EdgeInsets.only(
                    left: 32,
                    right: 32,
                  ),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Wpisz miasto",
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w200,
                            color: Colors.white70),
                      ),
                      SizedBox(
                        height: 102,
                      ),
                      TextFormField(
                        controller: cityController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.white70,
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                  color: Colors.white70,
                                  style: BorderStyle.solid)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                  color: Colors.blue,
                                  style: BorderStyle.solid)),
                          hintText: "Wpisz nazwę miasta!",
                          hintStyle: TextStyle(color: Colors.white70),
                        ),
                        style: TextStyle(color: Colors.white70),
                      ),
                      SizedBox(
                        height: 102,
                      ),
                      Container(
                        width: double.infinity,
                        height: 50,
                        child: FlatButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25))),
                          onPressed: () {
                            weatherBloc.add(FetchWeather(cityController.text));
                          },
                          color: Colors.lightBlue,
                          child: Text(
                            "Szukaj",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              else if (state is WeatherIsLoading)
                return Center(child: CircularProgressIndicator());
              else if (state is WeatherIsLoaded)
                return ShowWeather(state.getWeather, cityController.text);
              else
                return Container(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Przepraszamy, nie znaleziono lokalizacji",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ),
                      SizedBox(
                        height: 300,
                      ),
                      Container(
                        width: double.infinity,
                        height: 50,
                        child: FlatButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          onPressed: () {
                            BlocProvider.of<WeatherBloc>(context)
                                .add(ResetWeather());
                          },
                          color: Colors.lightBlue,
                          child: Text(
                            "Szukaj ponownie",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
            },
          )
        ],
      ),
    );
  }
}

class ShowWeather extends StatelessWidget {
  WeatherModel weather;
  final city;

  ShowWeather(this.weather, this.city);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Text(
          weather.getCity,
          style: TextStyle(
              color: Colors.white70, fontSize: 64, fontWeight: FontWeight.bold),
        ),
        Text(
          "Temperatura: " + weather.getTemp + "°C",
          style: TextStyle(color: Colors.white70, fontSize: 36),
        ),
        Text(
          "Ciśnienie: " + weather.pressure.toString() + " hPa",
          style: TextStyle(color: Colors.white70, fontSize: 36),
        ),
        Image.network(
          weather.iconUrl,
          scale: 0.01,
          height: 120,
        ),
        Text(
          weather.description.toString(),
          style: TextStyle(color: Colors.white70, fontSize: 24),
        ),
        SizedBox(
          height: 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  "Wschód",
                  style: TextStyle(color: Colors.white70, fontSize: 24),
                ),
                Text(
                  weather.getSunrise,
                  style: TextStyle(color: Colors.white70, fontSize: 36),
                )
              ],
            ),
            Column(
              children: <Widget>[
                Text(
                  "Zachód",
                  style: TextStyle(color: Colors.white70, fontSize: 24),
                ),
                Text(
                  weather.getSunset,
                  style: TextStyle(color: Colors.white70, fontSize: 36),
                )
              ],
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          width: 400,
          height: 50,
          child: FlatButton(
            shape: new RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            onPressed: () {
              BlocProvider.of<WeatherBloc>(context).add(ResetWeather());
            },
            color: Colors.lightBlue,
            child: Text(
              "Wyszukaj ponownie",
              style: TextStyle(color: Colors.white70, fontSize: 24),
            ),
          ),
        )
      ],
    ));
  }
}

class ShowWeatherGrand extends StatelessWidget {
  WeatherModel weather;
  final city;

  ShowWeatherGrand(this.weather, this.city);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Text(
          weather.getCity,
          style: TextStyle(
              color: Colors.white70, fontSize: 64, fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              weather.getTemp + "°C",
              style: TextStyle(color: Colors.white70, fontSize: 48),
            ),
            Text(
              weather.pressure.toString() + " hPa",
              style: TextStyle(color: Colors.white70, fontSize: 48),
            ),
          ],
        ),
        Image.network(
          weather.iconUrl,
          scale: 0.01,
          height: 120,
        ),
        Text(
          weather.description.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70, fontSize: 36),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  "Wschód",
                  style: TextStyle(color: Colors.white70, fontSize: 48),
                ),
                Text(
                  weather.getSunriseSmol,
                  style: TextStyle(color: Colors.white70, fontSize: 64),
                )
              ],
            ),
            Column(
              children: <Widget>[
                Text(
                  "Zachód",
                  style: TextStyle(color: Colors.white70, fontSize: 48),
                ),
                Text(
                  weather.getSunsetSmol,
                  style: TextStyle(color: Colors.white70, fontSize: 64),
                )
              ],
            ),
          ],
        ),
        Container(
          width: 400,
          height: 100,
          child: FlatButton(
            shape: new RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            onPressed: () {
              BlocProvider.of<WeatherBloc>(context).add(ResetWeather());
            },
            color: Colors.lightBlue,
            child: Text(
              "Szukaj",
              style: TextStyle(color: Colors.white70, fontSize: 56),
            ),
          ),
        )
      ],
    ));
  }
}
