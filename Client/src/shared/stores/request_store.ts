import { defineStore } from "pinia";
import type {
  Request,
  RequestInsert,
  RequestResponse,
  RequestUpdate,
  RequestFiltered,
} from "@/shared/types/request_model";
import { getRequestsByState, insertRequest, updateRequest, getRequestByID, getRequestByStudentRut, getRequestsByDateRange, getRequestsByStudentRol, getFilteredRequests } from "@/shared/services/api/request_api";
import { RequestStates } from "@/shared/enums/request_states";

interface State {
  requests: RequestResponse[];
  count_pending_requests: number;
  filter_requests: RequestResponse[];
  error: Error | null;
}

export const useRequestStore = defineStore("request", {
  state: (): State => ({
    requests: [],
    count_pending_requests: 0,
    filter_requests: [],
    error: null,
  }),
  getters: {
    allSendRequests: (state) => state.requests,
    countPendingRequests: (state) => state.count_pending_requests,
    filterRequests: (state) => state.filter_requests,
  },
  actions: {

    async getSendRequestsStore() {
      try {
        this.requests = await getRequestsByState(RequestStates.ENVIADA);
        this.count_pending_requests = this.requests.length;
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
    },

    async getRequestByIDStore(id: number) {
      try {
        return await getRequestByID(id);
      } catch (error) {
        this.error = error as Error;
        throw error;
      }
    },

    async getRequestByStudentRutStore(rut: string) {
      try {
        return await getRequestByStudentRut(rut);
      } catch (error) {
        this.error = error as Error;
        throw error;
      }
    },

    async getRequestsByDateRangeStore(date1: string, date2: string) {
      try {
        return await getRequestsByDateRange(date1, date2);
      } catch (error) {
        this.error = error as Error;
        throw error;
      }
    },

    async getRequestsByStudentRolStore(rol: string) {
      try {
        return await getRequestsByStudentRol(rol);
      } catch (error) {
        this.error = error as Error;
        throw error;
      }
    },

    async getFilteredRequestsStore(filter: RequestFiltered) {
      try {
        this.filter_requests = await getFilteredRequests(filter);
      } catch (error) {
        this.error = error as Error;
        throw error;
      }
    },
  },
});
