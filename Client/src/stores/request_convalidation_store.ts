import { defineStore } from "pinia";
import type {
  Request,
  RequestInsert,
  RequestResponse,
  RequestUpdate,
} from "@/interfaces/request_model";
import { getRequestsByState, insertRequest, updateRequest } from "@/services/request_api";
import { RequestStates } from "@/enums/request_states";

interface State {
  requests: RequestResponse[];
  error: Error | null;
}

export const useRequestStore = defineStore("request", {
  state: (): State => ({
    requests: [],
    error: null,
  }),
  getters: {
    allSendRequests: (state) => state.requests,
  },
  actions: {

    async getSendRequestsStore() {
      try {
        this.requests = await getRequestsByState(RequestStates.ENVIADA);
      } catch (error) {
        this.error = error as Error;
        throw error;
      }
    },

    async insertRequestStore(request: RequestInsert) {
      try {
        await insertRequest(request);
        await this.getSendRequestsStore();
      } catch (error) {
        this.error = error as Error;
        throw error;
      }
    },

    async updateRequestStore(request: RequestUpdate) {
      try {
        await updateRequest(request);
        await this.getSendRequestsStore();
      } catch (error) {
        this.error = error as Error;
        throw error;
      }
    }
  },
});
