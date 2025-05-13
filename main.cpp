#include "MyListModel.h"

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    MyListModel model;
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("myModel", QVariant::fromValue(&model));
    engine.load(QUrl(QLatin1String("qrc:/main.qml")));
    return app.exec();
}
