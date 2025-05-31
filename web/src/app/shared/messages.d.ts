export type Message = {
  id: string;
  conv_id: string;
  ts: number;
  sender: string;
  message: string;
  correction?: string | null;
  token_count?: null | number;
  error?: string | null;
};

export type CreateMessageRequest = {
  conv_id: string;
  message: string;
};

export type CreateMessageResponse = {
  response: string;
  correction: string | null;
};
