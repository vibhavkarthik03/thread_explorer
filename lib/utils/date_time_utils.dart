extension Timestamp on String {

  String timeAgoFromMs() {
    final now = DateTime.now();
    final time = DateTime.parse(this);

    final diff = now.difference(time);

    if (diff.inSeconds < 60) return "just now";

    if (diff.inMinutes < 60) {
      final m = diff.inMinutes;
      return "$m minute${m == 1 ? '' : 's'} ago";
    }

    if (diff.inHours < 24) {
      final h = diff.inHours;
      return "$h hour${h == 1 ? '' : 's'} ago";
    }

    if (diff.inDays < 30) {
      final d = diff.inDays;
      return "$d day${d == 1 ? '' : 's'} ago";
    }

    final months = diff.inDays ~/ 30;
    if (months < 12) {
      return "$months month${months == 1 ? '' : 's'} ago";
    }

    final years = diff.inDays ~/ 365;
    return "$years year${years == 1 ? '' : 's'} ago";
  }

}