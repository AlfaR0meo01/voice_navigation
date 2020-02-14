import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart';

///////////////////////////////////////////
Color fromHex(String hexString) {
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}

/////////////////////////////////////////////

class Voice extends StatefulWidget {
  const Voice({Key key}) : super(key: key);

  @override
  _VoiceState createState() => _VoiceState();
}

class _VoiceState extends State<Voice> {
  SpeechRecognition _speechRecognition;
  bool _isAvailable = false;
  bool _isListening = false;

  String placas =
      '["placa","placas","matricula","matriculas","matrículas","matrícula"]';

  String resultado_texto = '';
  String deb = '';

  @override
  void initState() {
    super.initState();
    initSpeechRecognizer();
  }

  void initSpeechRecognizer() {
    //inicializa el campo _speechRecognition como un objeto
    _speechRecognition = SpeechRecognition();

    //regresa valor booleano y mete dentro del campo _isAvailable
    _speechRecognition.setAvailabilityHandler(
      (bool result) => setState(() => _isAvailable = result),
    );

    //ejecuta cuando se empieza _speechRecognition y sabe cuando el microfono esta escuchando
    _speechRecognition.setRecognitionStartedHandler(
      () => setState(() => _isListening = true),
    );

    //regresa como resultado lo que eschucaba a texto
    _speechRecognition.setRecognitionResultHandler(
      (String speech) => setState(() => resultado_texto = speech),
    );

    // speechRecognition deja de escuchar por microfono
    _speechRecognition.setRecognitionCompleteHandler(
      () => setState(() => {
            _isListening = false,
          }),
    );

    _speechRecognition.activate().then(
          (result) => setState(() => _isAvailable = result),
        );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //botones para incizalizar ,cancelar y terminar conversacion
                /*IconButton(
                    icon: Icon(Icons.stop),
                    onPressed: () {
                      try {
                        if (_isListening) {
                          _speechRecognition
                              .cancel()
                              .then((result) => setState(() {
                                    _isListening = result;
                                    resultado_texto = '';
                                  }));
                        } else {
                          setState(() => resultado_texto = '');
                        }
                      } catch (error) {
                        print('${error.toString()} en linea 86');
                      }
                    }),*/
                IconButton(
                    icon: Icon(Icons.mic),
                    onPressed: () {
                      if (_isAvailable && !_isListening) {
                        _speechRecognition
                            .listen(locale: 'en_US')
                            .then((result) => setState(() => {
                                  resultado_texto: '$result',
                                }));
                      }
                    })
                /*IconButton(
                  icon: Icon(Icons.pause),
                  onPressed: () {
                    try {
                      if (_isListening) {
                        _speechRecognition.stop().then(
                            (result) => setState(() => _isListening = result));
                      }
                    } catch (error) {
                      print('${error.toString()} en linea 113');
                    }
                  },
                ),*/
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * .1,
              decoration: BoxDecoration(
                  color: Colors.cyanAccent[100],
                  borderRadius: BorderRadius.circular(6.0)),
              child: Text(
                resultado_texto,
                style: TextStyle(fontSize: 24.0),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * .2,
              child: Text(
                placas.contains('$resultado_texto')
                    ? 'Debes buscar placas, dijiste $resultado_texto'
                    : 'Palabra $resultado_texto no es un comando valido',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
