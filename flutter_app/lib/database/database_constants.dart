class DatabaseConstants {
  static final sessionTable = 'session';

  static final String sessionColumnId = 'session_id';
  static final String sessionColumnName = 'name';
  static final String sessionColumnTimestamp = 'timestamp';
  static final String sessionColumnFKUserId = 'userId';
  static final String sessionColumnSessionDeleted = 'deleted';
  static final String sessionColumnSessionSent = 'sent';

  static final sessionCodeTable = 'session_code';

  static final String sessionCodeColSessionId = 'session_id';
  static final String sessionCodeColCode = 'code';
  static final String sessionCodeColDeleted = 'deleted';

  static final String bookTable = 'book';
  static final String bookColumnCode = 'code';
  static final String bookColumnTitle = 'title';
  static final String bookColumnAuthor1 = 'author1';
  static final String bookColumnAuthor2 = 'author_2';
  static final String bookColumnAuthor3 = 'author_3';
  static final String bookColumnAuthor4 = 'author_4';
  static final String bookColumnAuthor5 = 'author_5';
  static final String bookColumnPublishedDate = 'published_date';
  static final String bookColumnPageCount = 'page_count';
  static final String bookColumLanguage = 'language';
  static final String bookColumnDeleted = 'deleted';
}
