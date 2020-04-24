import 'package:glaksoalcovid/components/App.dart';
import 'package:glaksoalcovid/components/src/trans_item.dart';
import 'package:glaksoalcovid/providers/transcription.dart';
import "package:timeago/timeago.dart" as timeago;
class Name {}

class TransImageViewEditElement extends StatelessWidget {
  TranscriptionProvider provider;

  @override
  Widget build(BuildContext context) {
    provider  = new TranscriptionProvider();
    provider.getElements();
    return StreamBuilder(
        stream: provider.createStreamElements.stream,
        builder: (BuildContext ctx,
            AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            return new TrasnImage(
                getMore: provider.getElements, data: snapshot.data);
          } else {
            return new Center(child: CircularProgressIndicator());
          }
        },
      );
  }
}

class TrasnImage extends StatelessWidget {
  ScrollController _controller;
  Function() getMore;
  List<Map<String, dynamic>> data;
  TrasnImage({this.getMore, this.data});

  @override
  Widget build(BuildContext context) {
    _controller = new PageController();
    _controller.addListener(() {
      if (_controller.position.pixels ==
          _controller.position.maxScrollExtent) {
        getMore();
        debugPrint("ON: call()-> scrool");
      }
    });
    return new Container(
        child: new ListView.builder(
            controller: _controller,
            itemCount: data.length,
            itemBuilder: (BuildContext ctx, int i) {
              return new TranscriptionItem(
                ago: timeago.format(DateTime.parse(data[i]["on_time"].split("@")[0]),locale: "es"),
                fill: data[i]["extra"],
                indentificador: data[i]["person_id"],
              );
            }));
  }
}
