import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TempView(),
    );
  }
}

class TempView extends StatefulWidget {
  const TempView({super.key});

  @override
  State<TempView> createState() => _TempViewState();
}

class _TempViewState extends State<TempView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Dock(
            items: const [
              Icons.person,
              Icons.message,
              Icons.call,
              Icons.camera,
              Icons.photo,
            ],
            builder: (e) {
              return Container(
                constraints: const BoxConstraints(minWidth: 48),
                height: 48,
                key: ValueKey(DateTime.now().toIso8601String()),
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.primaries[e.hashCode % Colors.primaries.length],
                ),
                child: Center(child: Icon(e, color: Colors.white)),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Dock of the reorderable [items].
class Dock<T> extends StatefulWidget {
  const Dock({
    super.key,
    this.items = const [],
    required this.builder,
  });

  /// Initial [T] items to put in this [Dock].
  final List<T> items;

  /// Builder building the provided [T] item.
  final Widget Function(T) builder;

  @override
  State<Dock<T>> createState() => _DockState<T>();
}

/// State of the [Dock] used to manipulate the [_items].
class _DockState<T> extends State<Dock<T>> {
  /// [T] items being manipulated.
  late final List<T> _items = widget.items.toList();
  late final List<GlobalKey> _keys =
      List.generate(_items.length, (index) => GlobalKey());

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _dragArea(),
        _bottomMenu()
      ],
    );
  }

  Widget _bottomMenu() {
   return Align(
    alignment: Alignment.bottomCenter,
     child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(_items.length, (index) {
            return AnimatedContainer(
              key: _keys[index],
              duration: const Duration(milliseconds: 300),
              child: _buildDraggableItem(index),
            );
          }),
        ),
   );
  }

  Widget _dragArea() {
    return DragTarget<int>(
      onWillAcceptWithDetails: (details) => false,
      builder: (context, candidateData, rejectedData) =>
          Container(color: Colors.white),
    );
  }

  Widget _buildDraggableItem(int index) {
    return Draggable<int>(
      data: index,
      axis: Axis.horizontal,
      feedback: widget.builder(_items[index]),
      childWhenDragging: const SizedBox.shrink(),
      child: widget.builder(_items[index]),
    );
  }
}
