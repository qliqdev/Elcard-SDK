export interface Theme {
  accentColor?: string;
  backgroundColor?: string;
  borderColor?: string;
  foregroundColor?: string;
  inputViewBackgroundColor?: string;
  textColor?: string;
}

export type Language = 'ru' | 'ky' | 'en';

export interface ElcartSDKPlugin {
  bindCard(options?: { theme?: Theme, language: Language }): Promise<{ code?: string, data: string }>;
}
