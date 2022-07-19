#ifndef CUSTOMDOCUMENT_H
#define CUSTOMDOCUMENT_H

#include <QtGui>
#include <QTextEdit>
#include "textedit.h"

class CustomDocument : public TextEdit
{
    Q_OBJECT
public:
    CustomDocument(QWidget *parent = Q_NULLPTR);
    void setDocumentPadding(int left, int top, int right, int bottom);
};

#endif // CUSTOMDOCUMENT_H
