abstract class ProjectEntity {
  String? id;
  dynamic? parentId;
  int? order;
  String? color;
  String? name;
  int? commentCount;
  bool? isShared;
  bool? isFavorite;
  bool? isInboxProject;
  bool? isTeamInbox;
  String? url;
  String? viewStyle;
  ProjectEntity(
      {this.id,
        this.parentId,
        this.order,
        this.color,
        this.name,
        this.commentCount,
        this.isShared,
        this.isFavorite,
        this.isInboxProject,
        this.isTeamInbox,
        this.url,
        this.viewStyle});
}