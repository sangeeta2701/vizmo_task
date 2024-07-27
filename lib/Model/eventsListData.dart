// To parse this JSON data, do
//
//     final eventsListData = eventsListDataFromJson(jsonString);

import 'dart:convert';

EventsListData eventsListDataFromJson(String str) => EventsListData.fromJson(json.decode(str));

String eventsListDataToJson(EventsListData data) => json.encode(data.toJson());

class EventsListData {
    List<Datum> data;

    EventsListData({
        required this.data,
    });

    factory EventsListData.fromJson(Map<String, dynamic> json) => EventsListData(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    DateTime createdAt;
    String title;
    String description;
    Status status;
    DateTime startAt;
    int duration;
    String id;
    List<String> images;

    Datum({
        required this.createdAt,
        required this.title,
        required this.description,
        required this.status,
        required this.startAt,
        required this.duration,
        required this.id,
        required this.images,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        createdAt: DateTime.parse(json["createdAt"]),
        title: json["title"],
        description: json["description"],
        status: statusValues.map[json["status"]]!,
        startAt: DateTime.parse(json["startAt"]),
        duration: json["duration"],
        id: json["id"],
        images: List<String>.from(json["images"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "createdAt": createdAt.toIso8601String(),
        "title": title,
        "description": description,
        "status": statusValues.reverse[status],
        "startAt": startAt.toIso8601String(),
        "duration": duration,
        "id": id,
        "images": List<dynamic>.from(images.map((x) => x)),
    };
}

enum Status {
    CANCELLED,
    CONFIRMED
}

final statusValues = EnumValues({
    "Cancelled": Status.CANCELLED,
    "Confirmed": Status.CONFIRMED
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
