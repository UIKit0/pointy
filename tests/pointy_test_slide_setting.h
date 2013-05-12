#ifndef POINTY_TEST_SLIDE_SETTING_H
#define POINTY_TEST_SLIDE_SETTING_H


#include "../src/slide_list_model.h"
#include <QtTest/QtTest>
#include <qsharedpointer.h>

namespace pointy {

class TestSlideSetting : public QObject
{
    Q_OBJECT
public:
    TestSlideSetting();

private:
    QSharedPointer<SlideData> testSlide;

private slots:
    void assignSlideSettings();


};

}

#endif // POINTY_TEST_SLIDE_SETTING_H