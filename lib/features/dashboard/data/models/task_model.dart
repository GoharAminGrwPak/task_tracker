import 'package:task_tracker/features/dashboard/domain/entities/task_entity.dart';

class TaskModel extends TaskEntity{
  TaskModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    assignerId = json['assigner_id'];
    assigneeId = json['assignee_id'];
    projectId = json['project_id'];
    sectionId = json['section_id'];
    parentId = json['parent_id'];
    order = json['order'];
    content = json['content'];
    description = json['description'];
    isCompleted = json['is_completed'];
    amount = json['amount'];
    unit = json['unit'];
    if (null != json['labels']) {
      labels = <String>[];
      json['labels'].forEach((v) {
        labels?.add('${v}');
      });
    }
    date = json['date'];
    string = json['string'];
    lang = json['lang'];
    isRecurring = json['is_recurring'];
    priority = json['priority'];
    commentCount = json['comment_count'];
    creatorId = json['creator_id'];
    createdAt = json['created_at'];
    due = null!=json['due']  ? new TaskModel.fromJson(json['due']) : null;
    duration = null!=json['duration']  ? new TaskModel.fromJson(json['duration']) : null;
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['assigner_id'] = this.assignerId;
    data['assignee_id'] = this.assigneeId;
    data['project_id'] = this.projectId;
    data['section_id'] = this.sectionId;
    data['parent_id'] = this.parentId;
    data['order'] = this.order;
    data['content'] = this.content;
    data['description'] = this.description;
    data['is_completed'] = this.isCompleted;
    if (this.labels != null) {
      data['labels'] = this.labels!.map((v) => v.toJson()).toList();
    }
    data['priority'] = this.priority;
    data['comment_count'] = this.commentCount;
    data['creator_id'] = this.creatorId;
    data['created_at'] = this.createdAt;
    // if (null!=this.due) {
    //   data['due'] = this.due!.toJson();
    // }
    data['date'] = this.date;
    data['string'] = this.string;
    data['lang'] = this.lang;
    data['is_recurring'] = this.isRecurring;
    data['url'] = this.url;
    data['duration'] = this.duration;
    return data;
  }
}