import 'database.dart';

class Translate {
  static Map<String, Map<String, String>> translate = {
    'date_time_conflict': {
      'en-gb': 'Date Time Conflict',
      'zh-hk': '日期時間衝突',
    },
    'type': {
      'en-gb': 'Type',
      'zh-hk': '類型',
    },
    'add_ticket': {
      'en-gb': 'Add Ticket',
      'zh-hk': '加票',
    },
    'fee': {
      'en-gb': 'Fee',
      'zh-hk': '費用',
    },
    'create_event': {
      'en-gb': 'Create Event',
      'zh-hk': '創建新活動',
    },
    'server_back_online': {
      'en-gb': 'Server Back Online',
      'zh-hk': '服務器重新上線',
    },
    'server_still_down': {
      'en-gb': 'Server Still Down',
      'zh-hk': '服務器仍然停機',
    },
    'event_joined_successfully': {
      'en-gb': 'Joined Event Successfully',
      'zh-hk': '成功地參與活動',
    },
    'event_left_successfully': {
      'en-gb': 'Left Event Successfully',
      'zh-hk': '成功地退出活動',
    },
    'event_leave': {
      'en-gb': 'Leave Event',
      'zh-hk': '退出活動',
    },
    'ok': {
      'en-gb': 'Okay',
      'zh-hk': '好',
    },
    'restart_server': {
      'en-gb': 'Restart Server',
      'zh-hk': '重新啟動服務器',
    },
    'server_shutting_down': {
      'en-gb': 'Server Shutting Down',
      'zh-hk': '服務器正在關閉',
    },
    'view_details': {
      'en-gb': 'View Details',
      'zh-hk': '查看詳情',
    },
    'name': {
      'en-gb': 'Name',
      'zh-hk': '名稱',
    },
    'description': {
      'en-gb': 'Description',
      'zh-hk': '簡介',
    },
    'id': {
      'en-gb': 'ID',
      'zh-hk': 'ID',
    },
    'participant_limit': {
      'en-gb': 'Participant Limit',
      'zh-hk': '參加人數限制',
    },
    'home': {
      'en-gb': 'Home',
      'zh-hk': '主頁',
    },
    'color_scheme': {
      'en-gb': 'Appearance',
      'zh-hk': '外表',
    },
    'language': {
      'en-gb': 'Language',
      'zh-hk': '語言',
      'zh-cn': '语言',
    },
    'automatic': {
      'en-gb': 'Automatic',
      'zh-hk': '自動',
      'zh-cn': '自动',
    },
    'light': {
      'en-gb': 'Light',
      'zh-hk': '光',
      'zh-cn': '光',
    },
    'dark': {
      'en-gb': 'Dark',
      'zh-hk': '暗',
      'zh-cn': '暗',
    },
    'black': {
      'en-gb': 'Black',
      'zh-hk': '黑',
      'zh-cn': '黑',
    },
    'settings': {
      'en-gb': 'Settings',
      'zh-hk': '設定',
      'zh-cn': '设定',
    },
    'changelog': {
      'en-gb': 'Changelog',
      'zh-hk': '更變記錄',
      'zh-cn': '更变记录',
    },
    'contact_me': {
      'en-gb': 'Contact Me',
      'zh-hk': '聯絡我',
      'zh-cn': '联络我',
    },
    'share_on_whatsapp': {
      'en-gb': 'Share on WhatsApp',
      'zh-hk': '於 WhatsApp 分享',
      'zh-cn': '于 WhatsApp 分享',
    },
    'about': {
      'en-gb': 'About',
      'zh-hk': '關於',
      'zh-cn': '关于',
    },
    'error_occured': {
      'en-gb': 'An Error Occurred',
      'zh-hk': '發生錯誤',
      'zh-cn': '发生错误',
    },
    'loading': {
      'en-gb': 'Loading...',
      'zh-hk': '載入中...',
      'zh-cn': '載入中...',
    },
    'updated_at': {
      'en-gb': 'Last Updated At',
      'zh-hk': '上次更新時間',
      'zh-cn': '上次更新时间',
    },
    'close_navigation_drawer': {
      'en-gb': 'Open Navigation Drawer',
      'zh-hk': '關閉導航抽屜',
      'zh-cn': '关闭导航抽屉',
    },
    'open_navigation_drawer': {
      'en-gb': 'Close Navigation Drawer',
      'zh-hk': '打開導航抽屜',
      'zh-cn': '打开导航抽屉',
    },
    'back': {
      'en-gb': 'Back',
      'zh-hk': '返回',
      'zh-cn': '返回',
    },
    'show_menu': {
      'en-gb': 'Show Menu',
      'zh-hk': '顯示菜單',
      'zh-cn': '显示菜单',
    },
    'refresh': {
      'en-gb': 'Refresh',
      'zh-hk': '刷新',
      'zh-cn': '刷新',
    },
    'time': {
      'en-gb': 'Time',
      'zh-hk': '時間',
      'zh-cn': '时间',
    },
    'confirm': {
      'en-gb': 'OK',
      'zh-hk': '確認',
      'zh-cn': '确认',
    },
    'cancel': {
      'en-gb': 'Cancel',
      'zh-hk': '取消',
      'zh-cn': '取消',
    },
    'no_internet': {
      'en-gb': 'No Internet Connection...',
      'zh-hk': '沒有網絡連接...',
      'zh-cn': '没有网络连接...',
    },
    'no_data': {
      'en-gb': 'Data Not Available',
      'zh-hk': '沒有資訊',
      'zh-cn': '没有资讯',
    },
    'link_leave_app_confirm': {
      'en-gb': 'GO TO SITE',
      'zh-hk': '到鏈接去',
      'zh-cn': '到链接去',
    },
    'link_leave_app_cancel': {
      'en-gb': 'BACK',
      'zh-hk': '返回',
      'zh-cn': '返回',
    },
    'buy_coffee': {
      'en-gb': 'Buy me a Coffee',
      'zh-hk': '給我買杯咖啡',
    },
    'favourites': {
      'en-gb': 'Favourites',
      'zh-hk': '收藏夾',
      'zh-cn': '收藏夹',
    },
    'no_favourites': {
      'en-gb': "You don't have any favourited..",
      'zh-hk': '你沒有收藏...',
      'zh-cn': '你没有收藏...',
    },
    'elevation': {
      'en-gb': 'Elevation',
      'zh-hk': '提高',
      'zh-cn': '提高',
    },
    'previous_page': {
      'en-gb': 'Previous Page',
      'zh-hk': '上一頁',
      'zh-cn': '上一页',
    },
    'next_page': {
      'en-gb': 'Next Page',
      'zh-hk': '下一頁',
      'zh-cn': '下一页',
    },
    'delete_item': {
      'en-gb': 'Delete Item',
      'zh-hk': '刪除項目',
      'zh-cn': '删除项目',
    },
    'feature_not_supported': {
      'en-gb': 'This feature is not supported on your device..',
      'zh-hk': '您的設備不支持此功能..',
      'zh-cn': '您的设备不支持此功能..',
    },
    'mins': {
      'en-gb': ' mins',
      'zh-hk': ' 分鐘',
      'zh-cn': ' 分钟',
    },
    'link_leave_app_title': {
      'en-gb': 'Are you sure you want to leave ETS?',
      'zh-hk': '您確定離開下班列車嗎?',
      'zh-cn': '您确定离开下班列车吗',
    },
    'link_leave_app_desc': {
      'en-gb': 'This link is taking you to a site outside of ETS',
      'zh-hk': '此鏈接將您帶到下班列車以外的網站',
      'zh-cn': '此链接将您带到下班列车以外的网站',
    },
    "event_ticketing_system": {
      'en-gb': "Event Ticketing System",
      'zh-hk': "活動票務系統",
      'zh-cn': "活动票务系统"
    },
    "tickets": {
      'en-gb': "Tickets",
      'zh-hk': "門票",
      'zh-cn': "门票",
    },
    "signedIn": {
      'en-gb': "(Signed In)",
      'zh-hk': "已登錄）",
      'zh-cn': "（已登录）",
    },
    "event_ticketing_system_so": {
      'en-gb': "(Not Signed In)",
      'zh-hk': "（未登錄）",
      'zh-cn': "（未登录）"
    },
    'en-gb': {
      'en-gb': "English",
      'zh-hk': "English",
      'zh-cn': "English",
    },
    'zh-hk': {
      'en-gb': "繁體中文",
      'zh-hk': "繁體中文",
      'zh-cn': "繁體中文",
    },
    'zh-cn': {
      'en-gb': "简体中文",
      'zh-hk': "简体中文",
      'zh-cn': "简体中文",
    },
    "welcome": {
      'en-gb': "Welcome",
      'zh-hk': "歡迎",
      'zh-cn': "欢迎",
    },
    "username_email": {
      'en-gb': "Username / Email",
      'zh-hk': "用戶名稱／電郵",
      'zh-cn': "用户名称／电邮"
    },
    "password": {
      'en-gb': "Password",
      'zh-hk': "密碼",
      'zh-cn': "密码",
    },
    "login_error_msg": {
      'en-gb': "Incorrect Username or Password",
      'zh-hk': "用戶名稱或密碼錯誤",
      'zh-cn': "用户名称或密码错误"
    },
    "login_success_msg_format": {
      'en-gb': "Signed in successfully as %s",
      'zh-hk': "以 %s 成功登錄",
      'zh-cn': "以 %s 成功登录"
    },
    "login": {
      'en-gb': "Login",
      'zh-hk': "登入",
      'zh-cn': "登入",
    },
    "logout": {
      'en-gb': "Logout",
      'zh-hk': "登出",
      'zh-cn': "登出",
    },
    "submit": {
      'en-gb': "Submit",
      'zh-hk': "提交",
      'zh-cn': "提交",
    },
    "register": {
      'en-gb': "Register",
      'zh-hk': "註冊",
      'zh-cn': "注册",
    },
    "open_app": {
      'en-gb': "Open Application",
      'zh-hk': "開啟程式",
      'zh-cn': "开启程式",
    },
    "quit": {
      'en-gb': "Quit",
      'zh-hk': "退出",
      'zh-cn': "退出",
    },
    "warning": {
      'en-gb': "Warning",
      'zh-hk': "警告",
      'zh-cn': "警告",
    },
    "quit_confirmation": {
      'en-gb': "Are you sure you want to quit?",
      'zh-hk': "你確定你要退出嗎？",
      'zh-cn': "你确定你要退出吗？"
    },
    "exit": {
      'en-gb': "Exit",
      'zh-hk': "離開",
      'zh-cn': "离开",
    },
    "events": {
      'en-gb': "Events",
      'zh-hk': "活動",
      'zh-cn': "活动",
    },
    "account": {
      'en-gb': "My Account",
      'zh-hk': "我的帳戶",
      'zh-cn': "我的帐户",
    },
    "event": {
      'en-gb': "Event",
      'zh-hk': "活動",
      'zh-cn': "活动",
    },
    "organiser": {
      'en-gb': "Organiser",
      'zh-hk': "組織者",
      'zh-cn': "组织者",
    },
    "status": {
      'en-gb': "Status",
      'zh-hk': "狀態",
      'zh-cn': "状态",
    },
    "start_date_time": {
      'en-gb': "Start",
      'zh-hk': "開始日期時間",
      'zh-cn': "开始日期时间",
    },
    "end_date_time": {
      'en-gb': "End",
      'zh-hk': "結束日期時間",
      'zh-cn': "结束日期时间",
    },
    "venue": {
      'en-gb': "Venue",
      'zh-hk': "會場",
      'zh-cn': "会场",
    },
    "theme": {
      'en-gb': "Theme",
      'zh-hk': "主題",
      'zh-cn': "主题",
    },
    "full": {
      'en-gb': "Full",
      'zh-hk': "滿",
      'zh-cn': "满",
    },
    "event_details": {
      'en-gb': "Event Details",
      'zh-hk': "活動詳情",
      'zh-cn': "活动详情",
    },
    "event_info": {
      'en-gb': "Event Information",
      'zh-hk': "活動資料",
      'zh-cn': "活动资​​料",
    },
    "from_date_time_to_date_time_format": {
      'en-gb': "From %s to %s",
      'zh-hk': "由 %s 至 %s",
      'zh-cn': "由 %s 至 %s"
    },
    "venue_theme_format": {
      'en-gb': "Held at %s, with theme of %s",
      'zh-hk': "在 %s 舉行，主題為 %s",
      'zh-cn': "在 %s 举行，主题为 %s"
    },
    "joined_events": {
      'en-gb': "Joined Events",
      'zh-hk': "你已參與的活動",
      'zh-cn': "你已参与的活动"
    },
    "joined": {
      'en-gb': "Joined",
      'zh-hk': "已參與",
      'zh-cn': "已参与",
    },
    "queued": {
      'en-gb': "Queued",
      'zh-hk': "排隊",
      'zh-cn': "排队",
    },
    "pending_events": {
      'en-gb': "Pending Events",
      'zh-hk': "待辦活動",
      'zh-cn': "待办活动",
    },
    "created_events": {
      'en-gb': "Created Events",
      'zh-hk': "你已創建的活動",
    },
    "manage_users": {
      'en-gb': "Manage Users",
      'zh-hk': "管理所有用戶",
      'zh-cn': "管理所有用户"
    },
    "first_name": {
      'en-gb': "First Name",
      'zh-hk': "名字",
      'zh-cn': "名字",
    },
    "last_name": {
      'en-gb': "Last Name",
      'zh-hk': "姓氏",
      'zh-cn': "姓氏",
    },
    "email": {
      'en-gb': "Email",
      'zh-hk': "電郵",
      'zh-cn': "电邮",
    },
    "username": {
      'en-gb': "Username",
      'zh-hk': "用戶名稱",
      'zh-cn': "用户名称",
    },
    "display_name": {
      'en-gb': "Display Name",
      'zh-hk': "顯示名稱",
      'zh-cn': "显示名称",
    },
    "err_first_name": {
      'en-gb': "Enter first name",
      'zh-hk': "輸入名字",
      'zh-cn': "输入名字"
    },
    "err_last_name": {
      'en-gb': "Enter last name",
      'zh-hk': "輸入姓氏",
      'zh-cn': "输入姓氏"
    },
    "err_email": {
      'en-gb': "Invalid Email",
      'zh-hk': "輸入電子郵件",
      'zh-cn': "输入电子邮件"
    },
    "err_too_long_max_format": {
      'en-gb': "Too long, maximum is %d characters",
      'zh-hk': "太長 最大為 ％d 個字符",
    },
    "err_username_format": {
      'en-gb': "Username must have %d - %d characters",
      'zh-hk': "用戶名必須包含 %d - %d 個字符",
      'zh-cn': "用户名必须包含 %d - %d 个字符"
    },
    "err_password_format": {
      'en-gb': "Password must have %d - %d characters",
      'zh-hk': "密碼必須包含 %d - %d 個字符",
      'zh-cn': "密码必须包含 %d - %d 个字符"
    },
    "err_username_taken": {
      'en-gb': "That username is taken, try another",
      'zh-hk': "該用戶名已被使用，請嘗試另一個",
      'zh-cn': "该用户名已被使用，请尝试另一个"
    },
    "err_email_registered": {
      'en-gb': "This email is already registered",
      'zh-hk': "該電子郵件已被註冊，請嘗試另一個",
      'zh-cn': "该电子邮件已被注册，请尝试另一个"
    },
    "err_display_name": {
      'en-gb': "Enter a display name",
      'zh-hk': "輸入顯示名稱",
      'zh-cn': "输入显示名称"
    },
    "err_password": {
      'en-gb': "Enter a password",
      'zh-hk': "輸入密碼",
      'zh-cn': "输入密码"
    },
    "confirm_password": {
      'en-gb': "Confirm password",
      'zh-hk': "確認密碼",
      'zh-cn': "确认密码"
    },
    "err_confirm_password": {
      'en-gb': "Confirm your password",
      'zh-hk': "確認你的密碼",
      'zh-cn': "确认你的密码"
    },
    "err_password_no_match": {
      'en-gb': "Those passwords didn't match, please try again",
      'zh-hk': "這些密碼不匹配，請重試",
      'zh-cn': "这些密码不匹配，请重试"
    },
    "account_type": {
      'en-gb': "Account Type",
      'zh-hk': "帳戶類型",
      'zh-cn': "帐户类型",
    },
    "participator": {
      'en-gb': "Participator",
      'zh-hk': "參加者",
      'zh-cn': "参加者",
    },
    "field_required": {
      'en-gb': "This field is required",
      'zh-hk': "此各項均為必填項",
      'zh-cn': "此各项均为必填项"
    },
    "register_remark_1": {
      'en-gb': "*All fields are required",
      'zh-hk': "*各項均為必填項",
      'zh-cn': "*各项均为必填项"
    },
    "register_remark_2": {
      'en-gb': "*Username must have %d - %d characters",
      'zh-hk': "*用戶名必須包含 %d - %d 個字符",
      'zh-cn': "*用户名必须包含 %d - %d 个字符"
    },
    "register_success": {
      'en-gb': "Registration successfully",
      'zh-hk': "用戶添加成功",
      'zh-cn': "用户添加成功"
    },
    "access_level_admin": {
      'en-gb': "Admin",
      'zh-hk': "管理員",
      'zh-cn': "管理员",
    },
    "admin": {
      'en-gb': "Admin",
      'zh-hk': "管理員",
      'zh-cn': "管理员",
    },
    "access_level_organiser": {
      'en-gb': "Organiser",
      'zh-hk': "組織者",
      'zh-cn': "组织者"
    },
    "access_level_default": {
      'en-gb': "Participator",
      'zh-hk': "參加者",
      'zh-cn': "参加者"
    },
    "access_level_anonymous": {
      'en-gb': "Anonymous",
      'zh-hk': "匿名者",
      'zh-cn': "匿名者"
    },
    "anonymous": {
      'en-gb': "Anonymous",
      'zh-hk': "匿名者",
      'zh-cn': "匿名者",
    },
    "join": {
      'en-gb': "Join",
      'zh-hk': "參加",
      'zh-cn': "参加",
    },
    "join_now": {
      'en-gb': "Join Now",
      'zh-hk': "立刻參加",
      'zh-cn': "立刻参加",
    },
    "join_waiting_list": {
      'en-gb': "Join Waiting List",
      'zh-hk': "加入等候名單",
      'zh-cn': "加入等候名单"
    }
  };

  static String get(String name) {
    String appLanguage = FeliStorageAPI().getLanguage();
    try {
      // return '...';
      return translate[name][appLanguage];
    } catch (e) {
      print('$name not found');
      return name;
    }
  }
}
