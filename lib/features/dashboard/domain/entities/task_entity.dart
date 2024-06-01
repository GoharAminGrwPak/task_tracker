class TaskEntity {
  String? id;
  dynamic? assignerId;
  dynamic? assigneeId;
  String? projectId;
  dynamic? sectionId;
  dynamic? amount;
  dynamic? parentId;
  dynamic? unit;
  int? order;
  String? content;
  String? description;
  bool? isCompleted;
  List<dynamic>? labels;
  int? priority;
  int? commentCount;
  String? creatorId;
  String? createdAt;
  TaskEntity? due;
  String? url;
  TaskEntity? duration;
  String? date;
  String? string;
  String? lang;
  bool? isRecurring;

  TaskEntity(
      {this.id,
        this.assignerId,
        this.assigneeId,
        this.projectId,
        this.sectionId,
        this.parentId,
        this.order,
        this.content,
        this.description,
        this.isCompleted,
        this.labels,
        this.priority,
        this.commentCount,
        this.creatorId,
        this.createdAt,
        this.due,
        this.url,
        this.date,
        this.amount,
        this.string,
        this.unit,
        this.lang,
        this.isRecurring,
        this.duration});


}

