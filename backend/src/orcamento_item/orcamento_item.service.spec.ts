import { Test, TestingModule } from '@nestjs/testing';
import { OrcamentoItemService } from './orcamento_item.service';

describe('OrcamentoItemService', () => {
  let service: OrcamentoItemService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [OrcamentoItemService],
    }).compile();

    service = module.get<OrcamentoItemService>(OrcamentoItemService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
