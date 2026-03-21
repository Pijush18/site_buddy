/// Centralized route constants for the application.
/// 
/// This file serves as the single source of truth for all navigation paths.
/// Use these constants instead of raw strings to prevent broken routes.
class AppRoutes {
  // --- CORE ROUTES ---
  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';
  static const resetPassword = '/reset-password';
  static const subscription = '/subscription';
  static const home = '/';
  
  // --- DASHBOARD / SHARED ---
  static const reports = '/reports';
  static const branding = '/settings/branding';
  static const reportPreview = '/report/preview';
  static const settings = '/settings';
  static const privacy = '/settings/privacy';
  static const terms = '/settings/terms';
  static const uiLab = '/dev/ui-lab';
  
  // --- CALCULATOR MODULE ---
  static const calculator = '/calculator';
  static const materialCalc = '/calculator/material';
  static const levelCalc = '/calculator/level';
  static const gradientCalc = '/calculator/gradient';
  static const cementCalc = '/calculator/cement';
  static const sandCalc = '/calculator/sand';
  static const rebarCalc = '/calculator/rebar';
  static const brickWallCalc = '/calculator/brick-wall';
  static const plasterCalc = '/calculator/plaster';
  static const excavationCalc = '/calculator/excavation';
  static const shutteringCalc = '/calculator/shuttering';
  
  // --- DESIGN MODULE ---
  static const design = '/design';
  
  // Slab Design
  static const slabInput = '/design/slab/input';
  static const slabLoad = '/design/slab/load';
  static const slabAnalysis = '/design/slab/analysis';
  static const slabReinforcement = '/design/slab/reinforcement';
  static const slabSafety = '/design/slab/safety';
  
  // Beam Design
  static const beamInput = '/design/beam/input';
  static const beamLoad = '/design/beam/load';
  static const beamAnalysis = '/design/beam/analysis';
  static const beamReinforcement = '/design/beam/rebar';
  static const beamSafety = '/design/beam/safety';
  
  // Column Design
  static const columnInput = '/design/column/input';
  static const columnHistory = '/design/column/input/history';
  static const columnLoad = '/design/column/load';
  static const columnSlenderness = '/design/column/slenderness';
  static const columnDesign = '/design/column/design';
  static const columnDetailing = '/design/column/detailing';
  static const columnSafety = '/design/column/safety';
  
  // Footing Design
  static const footingType = '/design/footing/type';
  static const footingLoad = '/design/footing/soil-load';
  static const footingGeometry = '/design/footing/geometry';
  static const footingAnalysis = '/design/footing/analysis';
  static const footingReinforcement = '/design/footing/reinforcement';
  static const footingSafety = '/design/footing/safety';
  
  // Common Design Tools
  static const designReport = '/design/report';
  static const shearCheck = '/design/shear-check';
  static const deflectionCheck = '/design/deflection-check';
  static const crackingCheck = '/design/cracking-check';
  
  // --- PROJECT MODULE ---
  static const projects = '/projects';
  static const projectCreate = '/projects/create';
  static const homeProjectCreate = '/project/create'; // Branch 0 version
  
  // Dynamic Project Routes
  static String projectDetail(String id) => '/projects/detail/$id';
  static String projectEdit(String id) => '/projects/$id/edit';
  static String projectShare(String id) => '/projects/$id/share';
  static String projectLevelLog(String id) => '/projects/$id/level-log';
  static String projectHistory(String id) => '/projects/$id/history';
  
  // --- WORK MODULE ---
  static const tasks = '/tasks';
  static const tasksDetail = '/tasks/detail';
  static const tasksCreate = '/tasks/create';
  static const meetingsDetail = '/meetings/detail';
  static const meetingsCreate = '/meetings/create';
  
  // --- AI MODULE ---
  static const aiInteraction = '/ai/interaction';
  static const aiChat = '/ai/chat';
  static const aiTopic = '/ai/topic';
  static const aiHistory = '/ai-history';
  static const aiShare = '/ai/share';
  
  // --- CONVERTERS ---
  static const unitConverter = '/converter';
  static const currencyConverter = '/currency';
  
  // --- MISC ---
  static const historyDetail = '/history-detail';
  static const levelLog = '/level'; // Branch 0 version? 
  // router.dart line 138 has path 'level' under Home '/', so '/level'
}
