export type Conversation = {
  _id: string;
  user_id: string;
  name: string;
  character: {
    name: string;
    gender: string;
    city: string;
    country: string;
  };
};

export type CreateConversationRequest = {
  name: string;
  character: {
    name: string;
    gender: string;
    city: string;
    country: string;
  };
};

export type CreateConversationResponse = {
  status: string;
  id: string;
};
