import 'package:task_tracker/features/dashboard/domain/entities/project_entity.dart';

class ProjectModelDto extends ProjectEntity{
  ProjectModelDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    order = json['order'];
    color = json['color'];
    name = json['name'];
    commentCount = json['comment_count'];
    isShared = json['is_shared'];
    isFavorite = json['is_favorite'];
    isInboxProject = json['is_inbox_project'];
    isTeamInbox = json['is_team_inbox'];
    url = json['url'];
    viewStyle = json['view_style'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parent_id'] = this.parentId;
    data['order'] = this.order;
    data['color'] = this.color;
    data['name'] = this.name;
    data['comment_count'] = this.commentCount;
    data['is_shared'] = this.isShared;
    data['is_favorite'] = this.isFavorite;
    data['is_inbox_project'] = this.isInboxProject;
    data['is_team_inbox'] = this.isTeamInbox;
    data['url'] = this.url;
    data['view_style'] = this.viewStyle;
    return data;
  }
}