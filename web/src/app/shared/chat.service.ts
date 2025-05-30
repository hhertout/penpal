import { Injectable } from '@angular/core';
import {
  Conversation,
  CreateConversationRequest,
  CreateConversationResponse,
} from './conversations';

@Injectable({ providedIn: 'root' })
export default class ChatService {
  BACKEND_URL = 'http://localhost:8000';

  async getConversations() {
    console.log('Fetching conversations');
    const response = await fetch(`${this.BACKEND_URL}/api/v1/conv`, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `${localStorage.getItem('token')}`,
      },
    });

    if (!response.ok) {
      throw new Error('Failed to fetch conversations');
    }

    const data = await response.json();

    return data as Array<Conversation>;
  }

  async createConversation(
    data: CreateConversationRequest
  ): Promise<CreateConversationResponse> {
    // todo
    return {} as CreateConversationResponse;
  }

  async getMessages(convId: string) {
    console.log('Fetching messages');
    const response = await fetch(
      `${this.BACKEND_URL}/api/v1/messages/${convId}`,
      {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `${localStorage.getItem('token')}`,
        },
      }
    );

    if (!response.ok) {
      throw new Error('Failed to fetch messages');
    }

    const data = await response.json();

    return data;
  }
}
