#ifndef ROOMMODEL_H
#define ROOMMODEL_H

#include <QObject>
#include <QString>

class RoomModel : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString roomId READ roomId WRITE setRoomId NOTIFY roomIdChanged)
    Q_PROPERTY(QString roomNumber READ roomNumber WRITE setRoomNumber NOTIFY roomNumberChanged)
    Q_PROPERTY(QString status READ status WRITE setStatus NOTIFY statusChanged)
    Q_PROPERTY(int bedCount READ bedCount WRITE setBedCount NOTIFY bedCountChanged)
    Q_PROPERTY(QString roomType READ roomType WRITE setRoomType NOTIFY roomTypeChanged)
    Q_PROPERTY(double price READ price WRITE setPrice NOTIFY priceChanged)
    Q_PROPERTY(QString description READ description WRITE setDescription NOTIFY descriptionChanged)
    Q_PROPERTY(QString image READ image WRITE setImage NOTIFY imageChanged)
    Q_PROPERTY(int guests READ guests WRITE setGuests NOTIFY guestsChanged)
    Q_PROPERTY(QString area READ area WRITE setArea NOTIFY areaChanged)

public:
    explicit RoomModel(QObject *parent = nullptr);

    QString roomId() const { return m_roomId; }
    void setRoomId(const QString &roomId);

    QString roomNumber() const { return m_roomNumber; }
    void setRoomNumber(const QString &roomNumber);

    QString status() const { return m_status; }
    void setStatus(const QString &status);

    int bedCount() const { return m_bedCount; }
    void setBedCount(int bedCount);

    QString roomType() const { return m_roomType; }
    void setRoomType(const QString &roomType);

    double price() const { return m_price; }
    void setPrice(double price);

    QString description() const { return m_description; }
    void setDescription(const QString &description);

    QString image() const { return m_image; }
    void setImage(const QString &image);

    int guests() const { return m_guests; }
    void setGuests(int guests);

    QString area() const { return m_area; }
    void setArea(const QString &area);

Q_SIGNALS:
    void roomIdChanged();
    void roomNumberChanged();
    void statusChanged();
    void bedCountChanged();
    void roomTypeChanged();
    void priceChanged();
    void descriptionChanged();
    void imageChanged();
    void guestsChanged();
    void areaChanged();

private:
    QString m_roomId;
    QString m_roomNumber;
    QString m_status;
    int m_bedCount;
    QString m_roomType;
    double m_price;
    QString m_description;
    QString m_image;
    int m_guests;
    QString m_area;
};

#endif // ROOMMODEL_H