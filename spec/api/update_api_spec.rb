describe Acme::UpdateAPI do
  describe 'POST' do
    context 'without params[:requestor]' do
      subject { post '/api/update' }

      it 'returns 400' do
        subject

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns an error' do
        subject

        expect(response.body).to eq({error: 'requestor is missing'}.to_json)
      end
    end

    context 'without params[:target]' do
      subject { post '/api/update', params: {requestor: 'a@example.com'} }

      it 'returns 400' do
        subject

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns an error' do
        subject

        expect(response.body).to eq({error: 'target is missing'}.to_json)
      end
    end

    context 'with params[:requestor]' do
      subject { post '/api/update', params: {requestor: requestor} }

      context 'when not given an email address' do
        let(:requestor) { [] }

        it 'returns 400' do
          subject

          expect(response).to have_http_status(:bad_request)
        end

        it 'returns an error' do
          subject

          expect(response.body).to eq({error: 'requestor is invalid'}.to_json)
        end
      end

      context 'when given an invalid email address' do
        let(:requestor) { 'invalid email' }

        it 'returns 400' do
          subject

          expect(response).to have_http_status(:bad_request)
        end

        it 'returns an error' do
          subject

          expect(response.body).to eq({error: 'requestor must be a valid email address.'}.to_json)
        end
      end

      context 'when given an email address' do
        context 'with params[:target]' do
          subject { post '/api/update', params: {requestor: requestor, target: target} }

          let(:requestor) { 'a@example.com' }

          context 'when not given an email address' do
            let(:target) { [] }

            it 'returns 400' do
              subject

              expect(response).to have_http_status(:bad_request)
            end

            it 'returns an error' do
              subject

              expect(response.body).to eq({error: 'target is invalid'}.to_json)
            end
          end

          context 'when given an invalid email address' do
            let(:target) { 'invalid email' }

            it 'returns 400' do
              subject

              expect(response).to have_http_status(:bad_request)
            end

            it 'returns an error' do
              subject

              expect(response.body).to eq({error: 'target must be a valid email address.'}.to_json)
            end
          end

          context 'when given an email address' do
            let(:target) { 'b@example.com' }

            it 'returns 201' do
              subject

              expect(response).to have_http_status(:created)
            end

            it 'returns the correct body' do
              subject

              expect(response.body).to eq({success: true}.to_json)
            end
          end
        end
      end
    end
  end

  describe 'block' do
    describe 'POST' do
      context 'without params[:requestor]' do
        subject { post '/api/update/block' }

        it 'returns 400' do
          subject

          expect(response).to have_http_status(:bad_request)
        end

        it 'returns an error' do
          subject

          expect(response.body).to eq({error: 'requestor is missing'}.to_json)
        end
      end

      context 'without params[:target]' do
        subject { post '/api/update/block', params: {requestor: 'a@example.com'} }

        it 'returns 400' do
          subject

          expect(response).to have_http_status(:bad_request)
        end

        it 'returns an error' do
          subject

          expect(response.body).to eq({error: 'target is missing'}.to_json)
        end
      end

      context 'with params[:requestor]' do
        subject { post '/api/update/block', params: {requestor: requestor} }

        context 'when not given an email address' do
          let(:requestor) { [] }

          it 'returns 400' do
            subject

            expect(response).to have_http_status(:bad_request)
          end

          it 'returns an error' do
            subject

            expect(response.body).to eq({error: 'requestor is invalid'}.to_json)
          end
        end

        context 'when given an invalid email address' do
          let(:requestor) { 'invalid email' }

          it 'returns 400' do
            subject

            expect(response).to have_http_status(:bad_request)
          end

          it 'returns an error' do
            subject

            expect(response.body).to eq({error: 'requestor must be a valid email address.'}.to_json)
          end
        end

        context 'when given an email address' do
          context 'with params[:target]' do
            subject { post '/api/update/block', params: {requestor: requestor, target: target} }

            let(:requestor) { 'a@example.com' }

            context 'when not given an email address' do
              let(:target) { [] }

              it 'returns 400' do
                subject

                expect(response).to have_http_status(:bad_request)
              end

              it 'returns an error' do
                subject

                expect(response.body).to eq({error: 'target is invalid'}.to_json)
              end
            end

            context 'when given an invalid email address' do
              let(:target) { 'invalid email' }

              it 'returns 400' do
                subject

                expect(response).to have_http_status(:bad_request)
              end

              it 'returns an error' do
                subject

                expect(response.body).to eq({error: 'target must be a valid email address.'}.to_json)
              end
            end
          end
        end
      end
    end
  end
end
