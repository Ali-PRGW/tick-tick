import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiktik/core/theme/app_theme.dart';
import 'package:tiktik/core/theme/theme_provider.dart';
import 'package:tiktik/data/data.dart';
import 'package:tiktik/features/edit_task_screen.dart';
import 'package:tiktik/features/task_item.dart';

const taskBoxName = 'tasks';

extension ThemeHelper on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Hive setting :
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(PriorityAdapter());
  await Hive.openBox<TaskEntity>(taskBoxName);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(
            WidgetsBinding.instance.platformDispatcher.platformBrightness,
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();

    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    Provider.of<ThemeProvider>(context, listen: false).updateTheme(brightness);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      //Theme setting :
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.brightness == Brightness.dark
          ? ThemeMode.dark
          : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final box = Hive.box<TaskEntity>(taskBoxName);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            Brightness.light,  
      ),
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => EditTaskScreen(task: TaskEntity(),)));
          },
          label: Row(
            children: [
              Icon(Icons.add),
              SizedBox(width: 2),
              Text("Add New Task"),
            ],
          ),
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryFixed,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'To Do List',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            themeProvider.toggleTheme();
                          },
                          icon: Icon(
                            themeProvider.brightness == Brightness.light
                                ? Icons.dark_mode
                                : Icons.light_mode,

                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(19),
                      ),
                      child: TextField(
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          isCollapsed: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          prefixIcon: const Icon(Icons.search, size: 20),
                          labelText: 'Search Tasks...',

                          labelStyle: const TextStyle(fontSize: 13),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.surface,

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(19),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 0.9,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ValueListenableBuilder<Box<TaskEntity>>(
                valueListenable: box.listenable(),
                builder: (context, box, child) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8 ,16, 8),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: box.values.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Today',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Container(
                                    height: 3,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  MaterialButton(
                                    onPressed: () {},
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.delete,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withOpacity(0.5),
                                        ),
                                        Text(
                                          'Delete All',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withOpacity(0.5),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        } else {
                          final TaskEntity task = box.values
                              .toList()[index - 1];
                          return TaskItem(task: task);
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
